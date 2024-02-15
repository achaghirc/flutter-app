import 'package:flutter/material.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/tickets/custom/tickets_grouped_dto.dart';
import 'package:my_app/infraestructure/models/tickets/tickets_dto.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';




class TicketCardEvent extends StatelessWidget {
  final TicketsGroupedDTO ticketsGrouped;
  const TicketCardEvent({
    super.key,
    required this.ticketsGrouped
  });

  BoxDecoration decoration(){
    return const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color> [
          //Theme.of(context).colorScheme.inversePrimary,
          Color.fromRGBO(86,204,255, 100),
          Color.fromRGBO(113,228,201, 100),
          Color.fromRGBO(143,255,140, 100),
        ]
      )
    );
  }

  double maxHeight(BuildContext context){
    if(ticketsGrouped.amount == 1){
      return MediaQuery.of(context).size.height * 0.3;
    }
    if(ticketsGrouped.amount > 1 && ticketsGrouped.amount <=2){
      return MediaQuery.of(context).size.height * 0.6;
    } 
    return MediaQuery.of(context).size.height * 0.8;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BottomSheetWidget.showModalBottomSheet(
          context, 
          _TicketCardDetails(tickets: ticketsGrouped.tickets), 
          maxHeight(context),
          MediaQuery.of(context).size.height * 0.3,
          null,
          decoration() 
        );
      },
      child: Stack(
          children: [
            Card (
              child: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color> [
                      //Theme.of(context).colorScheme.inversePrimary,
                      Color.fromRGBO(86,204,255, 100),
                      Color.fromRGBO(113,228,201, 100),
                      Color.fromRGBO(143,255,140, 100),
                    ])
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          ticketsGrouped.tickets.first.eventTicketEventName!,
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          ticketsGrouped.tickets.first.ticketsTypeEncoderName!,
                          style: GoogleFonts.nunito(
                            fontSize: 8,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    
                  ]
                ),
              ),
            ),
            ticketsGrouped.tickets.first.qrCode != null ?
              Positioned(
                top: MediaQuery.of(context).size.height * 0.045,
                left: MediaQuery.of(context).size.height * 0.030,
                child: 
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(                        
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            fit: BoxFit.cover,
                            image: MemoryImage(ticketsGrouped.tickets.first.qrCode!),
                          ),
                      ),
                  ),
              ): const SizedBox(),
            Positioned(
              right: 0,
              top: -5,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: Text(
                  'x${ticketsGrouped.amount}',
                  style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground
                  ),
                ),
              )
            )     
          ]
      ),
    );
  }
}


class _TicketCardDetails extends StatelessWidget {
  final List<TicketsDTO> tickets;
  const _TicketCardDetails({
    required this.tickets,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
      child: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (BuildContext context, index) {
          TicketsDTO ticket = tickets.elementAt(index);
          return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.eventTicketEventName!,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ticket.ticketsTypeEncoderName!,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${ticket.price.toString().replaceAll(globals.regex, '')} €',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(                        
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      fit: BoxFit.cover,
                      image: MemoryImage(ticket.qrCode!),
                    ),
                  ),
                ),
                Text(
                  ticket.ticketCode!,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Divider(
              height: 10,
              indent: 10,
              endIndent: 10,
              color: Colors.grey[500],
            )
          ],
        );
      }),
    );
  }
}