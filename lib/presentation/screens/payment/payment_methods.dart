import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/stripe/payment/payment_method_collection.dart';
import 'package:my_app/infraestructure/models/stripe/payment/payment_method_dto.dart';
import 'package:my_app/infraestructure/repositories/stripe/stripe_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';

class PaymentMethods extends ConsumerStatefulWidget {
  const PaymentMethods({super.key});

  @override
  ConsumerState<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends ConsumerState<PaymentMethods> {
  late JwtAuthenticationResponseDTO session;

  @override
  void initState() {
    super.initState();
    session = ref.read(sessionProvider).session!;
  }

  Future<PaymentMethodCollection> getUserCards() async{
    PaymentMethodCollection paymentMethodCollection =  await StripeRepositoryImpl(session).listCustomerCards(session.user.id);   
    return paymentMethodCollection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Formas de Pago',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: getUserCards(), 
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.data == null) {
                return Center(
                  child: Text(
                    'No tienes ninguna tarjeta guardada.',
                    style: GoogleFonts.nunito(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                    
                  ),
                );
              } 
              else {
                PaymentMethodCollection paymentMethodCollection = snapshot.data as PaymentMethodCollection;
                return ListView.separated(
                  separatorBuilder: (context, idx ) => const Divider(                    
                    endIndent: 10.0,
                    indent: 10.0,
                    height: 2,
                  ),
                  itemCount: paymentMethodCollection.data.length,
                  itemBuilder: (context, index) {
                    PaymentMethodDTO paymethod = paymentMethodCollection.data.elementAt(index);
                    return ListTile(
                      title: Text(
                        'Tarjeta ${index+1}',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(
                        '**** **** **** ${paymethod.card.last4}' ?? 'XXXX'
                      ),
                      leading: const Icon(Icons.credit_card),
                      trailing:  Wrap(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.delete_outline_outlined,
                            color: Theme.of(context).iconTheme.color,
                          )
                        ]
                      ),
                    );
                  },
                );
                
              }
            }
          ),
          // Positioned(
          //   bottom: MediaQuery.of(context).size.height * 0.03,
          //   right: MediaQuery.of(context).size.width * 0.04,
          //   child: TextButton(
          //     style: TextButton.styleFrom(
          //       backgroundColor: Theme.of(context).colorScheme.secondary,
          //       shape: const CircleBorder(),
          //       padding: const EdgeInsets.all(15)
          //     ),
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         return const CreditCardCreateWidget();
          //       }));
          //     }, 
          //     child: Icon(
          //       Icons.add_card_outlined,
          //       color: Theme.of(context).colorScheme.background,
          //     )
          //   ),
          // )
        ],
      ),
    );
  }
}