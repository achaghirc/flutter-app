import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/models/tickets/tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/tickets_repository_impl.dart';
import 'package:my_app/presentation/screens/payment/stripe/stripe_pay_screen.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';

//This widget is used in event screen details to buy the tickets.
class TicketEventBuyWidget extends StatefulWidget {
  final EventTicketsDTO ticket;
  final EventDTO event;
  final String? publicRelationCode;
  final JwtAuthenticationResponseDTO session;
  const TicketEventBuyWidget({
    super.key,
    required this.ticket,
    required this.event,
    required this.session,
    this.publicRelationCode
  });

  @override
  State<TicketEventBuyWidget> createState() => _TicketEventBuyWidgetState();
}

class _TicketEventBuyWidgetState extends State<TicketEventBuyWidget> {
  late int counter;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter = 0;
    if(widget.publicRelationCode == null){
      context.pushReplacementNamed('event_home');
    }
  }

  Future<List<TicketsDTO>> buyTicketProcess() async {
    setState(() {
      isLoading = true;
    });
    TicketsDTO ticketsDTO = TicketsDTO(
      name: '${widget.event.name}_${widget.ticket.ticketsTypeEncoderCode}_${widget.session.user.username}', 
      price: widget.ticket.price,  
      rrppCode: widget.publicRelationCode!, 
      buyDate: "${Moment(DateTime.now()).format("YYYY-MM-DDTHH:mm:ss")}Z", 
      ticketsTypeId: widget.ticket.ticketsTypeId, 
      ticketsTypeEncoderCode: widget.ticket.ticketsTypeEncoderCode!, 
      userId: int.parse(widget.session.user.id), 
      userUsername: widget.session.user.username, 
      eventTicketId: widget.ticket.id!, 
      eventTicketName: widget.ticket.name, 
      eventTicketEventDate: widget.event.startDate,
      eventTicketTicketCommission: widget.ticket.ticketCommission
    );
    List<TicketsDTO> ticketsList = [];
    for (var i = 0; i < counter; i++) {
      ticketsList.add(ticketsDTO);
    }
    //bool result = await TicketsRepositoryImpl(widget.session).create(ticketsList);
    setState(() {
      isLoading = false;
    });
    return ticketsList;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
          child: Text(
            widget.ticket.name.length > 18 ? '${widget.ticket.name.substring(0,18)}...' : widget.ticket.name,
            style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.onBackground,  
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 0),
          child: Text(
            widget.ticket.ticketsTypeEncoderDescription ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.onBackground,  
              fontSize: 18,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if(counter > 0){
                  setState(() {
                    counter = counter - 1;
                  });
                }
              }, 
              icon: const Icon(
                size: 30,
                Icons.remove_circle_outline_outlined
              )
            ),
            Text(
              '$counter',
              style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.onBackground,  
              fontSize: 18,
            ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  counter = counter + 1;
                });
              }, 
              icon: const Icon(
                size: 30,
                Icons.add_circle_outline_outlined
              )
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.08,
          padding: const EdgeInsets.fromLTRB(0,15,0,0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => counter > 0 ? 
              Theme.of(context).colorScheme.inversePrimary
              :
              Theme.of(context).colorScheme.secondary),
            ),
            onPressed: (){
              if(counter > 0){
                buyTicketProcess().then((value) {                
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StripePayScreen(tickets: value);
                  }));
                }).catchError((onError) {
                  CustomSnackBarWidget.openSnackBar(context, 'Error', onError.toString());
                  context.pop();
                });
              }
            }, 
            child: isLoading ? 
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
              :
              Text(
              'CREAR',
              style: GoogleFonts.nunito(
                fontSize: 18,
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.w400
              ),
            )
          ),
        )
      ],
    );
  }
}