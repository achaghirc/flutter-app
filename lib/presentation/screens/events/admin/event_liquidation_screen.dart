import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/event_tickets_grouped_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/tickets_grouped_dto.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/cards/card_event.dart';
import 'package:my_app/shared/widgets/custom/gradient_text.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_tickets.dart';

class EventLiquidationScreen extends ConsumerStatefulWidget {
  final EventDTO event;
  const EventLiquidationScreen({
    super.key,
    required this.event
  });

  @override
  ConsumerState<EventLiquidationScreen> createState() => _EventLiquidationScreenState();
}

class _EventLiquidationScreenState extends ConsumerState<EventLiquidationScreen> {
  late JwtAuthenticationResponseDTO session;
  late EventDTO _event;

  @override
  void initState() {
    super.initState();
    if(ref.read(sessionProvider).session == null){
      context.goNamed('signin');
    }
    session = ref.read(sessionProvider).session!;
    if(session.user.roleCode != 'ADMIN'){
      context.pushReplacementNamed('event_home_user');
    }
    _event = widget.event;

  }
  //List<EventTicketsGroupedDTO> eventTickets
  List<Widget> _buildEventTicketList(){
    List<Widget> list = [];
    List<int> test = [1,2,3,4];
    for(int i in test){
      Widget w = ListTile(
                  title: Text('Entrada $i'),
                );
      list.add(w);
    }
    return list;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liquidación',
          style: GoogleFonts.nunito(
            fontSize: 30
          ),
        ),
      ),
      body: ListView(
        children: [
          CardEvent(
            id: _event.id, 
            titleCard: _event.name, 
            subtitle: _event.description, 
            startDate: _event.startDate,
            images: _event.medias,
            status: _event.statusCode,
            heightFactor: 0.18,
            limitSubtitle: false,
          ),
          const HeaderSectionWidget(text: 'Cuenta Bancaria'),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Titular de la cuenta',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                    Text(
                      'Amine Chaghir Chikhaoui',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
                 SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número de cuenta',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                    Center(
                      child: Text(
                        'ES43 **** **** ** ******1798',
                        style: GoogleFonts.nunito(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center
                      ),
                    )
                  ],
                )
              ]
            ),
          ),
          // const HeaderSectionWidget(text: 'Resumen Entradas'),
          // FutureBuilder(
          //   future: Future.delayed(const Duration(milliseconds: 500)), 
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if(snapshot.connectionState == ConnectionState.waiting){
          //       return const ShimmedTicketsList(size: 3);
          //     // }else if(snapshot.data == null){
          //     //   return Center(
          //     //     child: Text(
          //     //       'No tienes entradas vendidas.',
          //     //       style: GoogleFonts.nunito(),
          //     //     ),
          //     //   );
          //     } else {
          //       //List<EventTicketsGroupedDTO> ticketsGroupedDTO = snapshot.data as List<EventTicketsGroupedDTO>;
          //       return Column(
          //         children: _buildEventTicketList()
                  
          //       );
          //     }
          //   }
          // ),
          const HeaderSectionWidget(text: 'Resumen del pago'),
          Column(
            children: [
              ListTile(
                title: Text(
                  'Entradas vendidas',
                  style: GoogleFonts.nunito()
                ),
                trailing: const Wrap(
                  children: [
                    Text('100')
                  ]
                ),
              ),
              Center(
                child: Text(
                  'Total a transferir',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Center(
                child: GradientText(
                  '250 €',
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
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * .05,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                      Color.fromRGBO(86,204,255, 100),
                      Color.fromRGBO(113,228,201, 100),
                      Color.fromRGBO(143,255,140, 100),
                    ]
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onPressed: (){
                      BottomSheetWidget.showDialogCenter(
                        context, 
                        _EventLiquidationAdviceDialog(event:_event, session:session)
                      );
                    },
                    icon: Icon(
                      Icons.payment_outlined,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    label: Text(
                      'LIQUIDAR',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


class HeaderSectionWidget extends StatelessWidget {
  final String text;
  const HeaderSectionWidget({
    super.key,
    required this.text  
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        const Divider(
          indent: 10.0,
          endIndent: 10.0,
          height: 5,
        ),
      ],
    );
  }
}

class _EventLiquidationAdviceDialog extends StatelessWidget {
  final EventDTO event;
  final JwtAuthenticationResponseDTO session;
  const _EventLiquidationAdviceDialog({
    super.key,
    required this.event,
    required this.session
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          'Liquidación de evento',
          style: GoogleFonts.nunito(),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            'Al liquidar el evento, todos los fondos relacionados con el mismo serán transferidos a la cuenta bancaria configurada. El evento a su vez, será cerrado y no podrá ser abierto de nuevo.',
            style: GoogleFonts.nunito()
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
          FilledButton(onPressed: () => {}, child: const Text('Continuar'))
        ],
    );
  }
}