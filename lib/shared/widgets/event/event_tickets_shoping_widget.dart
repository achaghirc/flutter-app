import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/event_tickets_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/event_tickets_query_params.dart';
import 'package:my_app/presentation/screens/tickets/shop/ticket_event_buy_widget.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';

class EventTicketsShoppingWidget extends StatelessWidget {
  final EventDTO event;
  final String? publicRelationCode;
  final JwtAuthenticationResponseDTO session;
  const EventTicketsShoppingWidget({
    super.key,
    required this.event,
    required this.session,
    this.publicRelationCode
  });
  Future<List<EventTicketsDTO>> searchTickets() async{
    try{
      EventTicketsQueryParams queryParams =  EventTicketsQueryParams(eventId: event.id, available: true);
      List<EventTicketsDTO> tickets = await EventTicketsRepositoryImpl(session).search(queryParams);
      return tickets;
    }catch(err) {
      print(err.toString());
    }
    return List.empty();
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            'Entradas',
            style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const Divider(
          endIndent: 10.0,
          indent: 10.0,
          height: 2,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: event.tickets!.length,
          separatorBuilder: (context, index) => 
            const Divider(
              color: Colors.black12,
              endIndent: 20.0,
              indent: 20.0,
              height: 5,
            ),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            EventTicketsDTO ticket = event.tickets!.elementAt(index);
            return ListTile(
              onTap: () {
                BottomSheetWidget.showModalBottomSheet(
                  context,
                  TicketEventBuyWidget(ticket: ticket, event: event,session: session, publicRelationCode: publicRelationCode),
                  MediaQuery.of(context).size.height * 0.3,
                  100,
                  null,
                  null,
                );
              },
              title: Text(
                ticket.name,
                style: GoogleFonts.nunito(
                      
                ),
              ),
              subtitle: Text(
                ticket.ticketsTypeEncoderName!,
                style: GoogleFonts.nunito(
                  
                ),
              ),
              leading: const Icon(
                Icons.local_activity_outlined
              ),
              trailing: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Text(
                      '${ticket.price}€',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        )
      ],
    );
  }
}