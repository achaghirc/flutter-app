import 'dart:math';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/stripe/customer/product_dto.dart';
import 'package:my_app/infraestructure/models/stripe/request_dto.dart';
import 'package:my_app/infraestructure/models/stripe/stripe_response_dto.dart';
import 'package:my_app/infraestructure/models/tickets/tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/stripe/stripe_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/tickets_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/providers/theme_provider.dart';
import 'package:my_app/shared/widgets/custom/gradient_text.dart';

class StripePayScreen extends ConsumerStatefulWidget {
  final List<TicketsDTO> tickets;
  final EventDTO event;
  const StripePayScreen({
    super.key,
    required this.tickets,
    required this.event
  });

  @override
  ConsumerState<StripePayScreen> createState() => _StripePayScreenState();
}

class _StripePayScreenState extends ConsumerState<StripePayScreen> {
  late bool isLoading = false;
  late bool isDarkMode;
  late List<TicketsDTO> _tickets;
  late double _ticketsAmount;
  late double _totalAmount;
  late double _ticketComission;
  late double _platformComission;
  Map<String, dynamic>? paymentIntent;
  late JwtAuthenticationResponseDTO session;

  double calculateRRPPTicketsComission(){
    return roundDouble(_tickets.map((e) => e.eventTicketTicketCommission ?? 0.0).reduce((a, b) => a+b), 2);
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places).roundToDouble(); 
    return ((value * mod).round().toDouble() / mod); 
  }


  double calculatePlatformCommission(){
    double value = (_tickets.map((e) => e.price).reduce((a, b) => a+b) * 1.5 / 100) + 0.25;
    return roundDouble(value, 2);
    //return _tickets.length * 0.5;
  }
  

  void totalAmount(){
    _ticketComission = 0.0;
    _platformComission = calculatePlatformCommission();
    double valueTotal = _tickets.map((e) => e.price).reduce((a, b) => a+b) + _ticketComission + _platformComission;
    _totalAmount = roundDouble(valueTotal, 2);
    _ticketsAmount = roundDouble(_totalAmount - _ticketComission - _platformComission, 2);
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDarkMode = ref.read(themeNotifierProvider).isDarkMode;
    session = ref.read(sessionProvider).session!;
    _tickets = widget.tickets;
    totalAmount();
  }

  Future<bool> initPaymentSheet(context) async {
    setState(() {
      isLoading = true;
    });
    String paymentIntentId = "";
    try{
      List<ProductDTO> products = [];
      for (var element in _tickets) {
        ProductDTO p = ProductDTO(name: element.eventTicketName, id: element.name.toString(), 
        unitAmountDecimal: element.price, currency: 'EUR');
        products.add(p);
      }
      
      RequestDTO requestDTO = RequestDTO(customerEmail: session.user.personEmail, 
      customerUsername: session.user.username, 
      adminUser: widget.event.userId,
      items: products, ticketsAmount: _ticketsAmount, platformCommission: _platformComission, rrppCommission: _ticketComission);

      ResponseStripePayment jsonResponse = await StripeRepositoryImpl(session).createPaymentIntent(requestDTO);
      paymentIntentId = jsonResponse.paymentIntentId;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse.paymentIntent,
          merchantDisplayName: '${_tickets.first.eventTicketEventName}/${_tickets.first.eventTicketName}',
          customerId: jsonResponse.customer,
          customerEphemeralKeySecret: jsonResponse.ephemeralKey,
          style: isDarkMode ? ThemeMode.dark : ThemeMode.light,          
        ));
      
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment completed'))
      );
      await TicketsRepositoryImpl(session).create(_tickets);
      setState(() {
        isLoading = false;
      });
      return true;
    }catch(e) {
      if(e is StripeException){
        await StripeRepositoryImpl(session).cancelPaymentIntent(paymentIntentId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error from Stripe: ${e.error.localizedMessage}'))
        );
        setState(() {
          isLoading = false;
        });
      }else{
        await StripeRepositoryImpl(session).cancelPaymentIntent(paymentIntentId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
        );
        setState(() {
          isLoading = false;
        });
      }
    }
    return false;
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Proceso de pago',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          Center(
            child: Text(
              'Vas a pagar',
              style: GoogleFonts.nunito(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Center(
            child: GradientText(
              '$_totalAmount €',
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(86,204,255, 100),
                Color.fromRGBO(113,228,201, 100),
                Color.fromRGBO(143,255,140, 100),
              ]),
              style: GoogleFonts.nunito(
                fontSize: 65,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Container(
            padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
            alignment: Alignment.centerLeft,
            child: Text(
              'Desglose',
              style: GoogleFonts.nunito(
                fontSize: 18,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const Divider(
            endIndent: 10.0,
            indent: 10.0,
            height: 2,
          ),
          ListTile(
            title: Text(
              _tickets.first.eventTicketName,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 18
              ),
            ),
            trailing: Text(
              '$_ticketsAmount €',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Comisión de gestión',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 18
              ),
            ),
            trailing: Text(
              '$_platformComission €',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Comisión de relaciones públicas',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 18
              ),
            ),
            trailing: Text(
              '$_ticketComission €',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.05,
            child: ElevatedButton(
              onPressed: (){
                initPaymentSheet(context).then((value) => {
                  session.user.roleCode == "RRPP" ? context.pushReplacementNamed('event_home_rrpp') : context.pushReplacementNamed('event_home') 
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary
              ),
              child: 
              isLoading ? 
              const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              :
              Text(
                "PAGAR",
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.surface
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
