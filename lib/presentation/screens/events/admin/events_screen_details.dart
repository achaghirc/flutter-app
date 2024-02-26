import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/image/imageDTO.dart';
import 'package:my_app/infraestructure/models/tickets/custom/event_public_relation_data_dto.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/event_public_relations_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/event_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/event_tickets_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/event_tickets_query_params.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/screens/events/admin/edit_event.dart';
import 'package:my_app/presentation/screens/tickets/shop/ticket_event_buy_widget.dart';
import 'package:my_app/presentation/screens/tickets/tickets_event_screen.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/cards/card_event.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/navigation/bottom_navigation_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_data_resume_widget.dart';
import 'package:my_app/shared/widgets/tickets/data_resume_widget.dart';

final List<ImageDTO> medias = [
  ImageDTO(title: "Default", type: "image/jpeg", data: Uint8List.fromList([]))
];


class EventsScreenDetails extends ConsumerWidget {
  final String? id;
  final String? publicRelationCode;
  final String? assigned;

  const EventsScreenDetails({
    super.key,
    required this.id,
    this.publicRelationCode,
    this.assigned
  });

  Future<EventDTO?> findEvent(JwtAuthenticationResponseDTO? session) async{
    String nonNullId = id ?? '0';
    if(nonNullId != '0'){      
      EventDTO? event = await EventRepositoryImpl(session).findEventById(nonNullId);
      return event;
    }else {
      return Future.delayed(const Duration(milliseconds: 300));
    }
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionProvider).session;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              onPressed: (){
                  context.pop();
              }, 
              icon: const Icon(Icons.arrow_back)
            );
          }
        ),
        actions: const [
          AppBarActions()
        ],
      ),
      body: FutureBuilder(
      future: findEvent(session),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!snapshot.hasData) {
          return const Center(
            child: Text(
              'No coincide con ningún evento'
            ),
          );
        }else {
          var event = snapshot.data as EventDTO;
          return  ListView(
              children: [
                CardEvent(
                  id: event.id, 
                  titleCard: event.name, 
                  subtitle: event.description, 
                  startDate: event.startDate,
                  images: event.medias,
                  heightFactor: 0.18,
                  limitSubtitle: false,
                ),
                const SizedBox(
                  height: 20
                ),
                publicRelationCode != 'ADMIN' ? 
                  Center(child: _RowChips(publicRelationCode: publicRelationCode))
                :
                const SizedBox(),
                const SizedBox(
                  height: 20
                ),
                assigned! == 'Y' && session!.user.roleCode == 'RRPP' ?
                  _EventPublicRelationResumeData(session: session, publicRelationCode: publicRelationCode ?? 'ADMIN')
                :
                const SizedBox(),
                //EVENT INFORMATION WIDGET
                _Information(event: event),
                //EVENT MANAGENMENT ONLY ROLE ADMIN
                session!.user.roleCode == 'ADMIN' ?
                  _EventManagementAdmin(event: event) 
                :              
                  _EventTicketsShoppingWidget(event: event, session: session,publicRelationCode: publicRelationCode)
              ],
            );
        }
      }
    ),
    bottomNavigationBar: const BottomNavigationBarWidget(),
  );
  }
}

class _RowChips extends StatelessWidget {
  final String? publicRelationCode;
  const _RowChips({
    this.publicRelationCode
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        publicRelationCode != 'ADMIN' ?
        Chip(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          label: Text(
            publicRelationCode ?? '',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.background
            ),
          ),
        ) : const SizedBox(),
        Chip(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          label: Text(
            'LINK',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.background
            ),
          ),
        ),
      ]
  );
  }
}
class _Information extends StatelessWidget {
  final EventDTO event;
  const _Information({
    required this.event
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [       
        Container(
          padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            'Información',
            style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.inverseSurface,
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
          onTap: (){},
          leading: Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
          title: Text(
            '${event.ubicationTypeRoad}, ${event.ubicationNameRoad}, ${event.ubicationTown}',
            style: GoogleFonts.nunito(),
            ),
          trailing:  Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
        ),
        const Divider(
            endIndent: 10.0,
            indent: 10.0,
            height: 2,
        ), 
        ListTile(
          onTap: (){},
          leading: Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.groups_outlined,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
          title: Text(
            'Mas información',
            style: GoogleFonts.nunito(),
            ),
          trailing:  Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
        ),
      ],
    );
  }
}
class _EventTicketsShoppingWidget extends StatelessWidget {
  final EventDTO event;
  final String? publicRelationCode;
  final JwtAuthenticationResponseDTO session;
  const _EventTicketsShoppingWidget({
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
class _EventManagementAdmin extends StatelessWidget {
  final EventDTO event;
  const _EventManagementAdmin({
    required this.event
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //GESTION SOLO PARA ROL ADMIN
        Container(
          padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            'Gestión',
            style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.inverseSurface,
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
        //RELACIONES PUBLICAS ASIGNADOS
        ListTile(
          onTap: (){
            context.pushReplacementNamed('event_squad_list',  pathParameters: {'eventId': event.id.toString()} );
          },
          leading: Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.groups_outlined,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
          title: Text(
            'Relaciones públicas asignados',
            style: GoogleFonts.nunito(),
            ),
          trailing:  Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
        ),
        const Divider(
          endIndent: 10.0,
          indent: 10.0,
          height: 2,
        ),
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TicketsEventScreen(event: event);
            }));
          },
          leading: Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.local_activity_outlined,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
          title: Text(
            'Entradas',
            style: GoogleFonts.nunito(),
            ),
          trailing:  Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
        ),
        const Divider(
          endIndent: 10.0,
          indent: 10.0,
          height: 2,
        ),
        ListTile(
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) {
                  return EditEvent(event: event);
                }
              )
            );
          },
          leading: Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.mode_edit_outline_outlined,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
          title: Text(
            'Editar evento',
            style: GoogleFonts.nunito(),
            ),
          trailing:  Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
        ),
        const Divider(
          endIndent: 10.0,
          indent: 10.0,
          height: 2,
        ),
        Container(
          height: MediaQuery.of(context).size.height * .07,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent
                ),
                onPressed: (){},
                icon: const Icon(
                  Icons.highlight_remove_outlined,
                  color: Colors.white,
                ),
                label: (
                  // isLoading ? 
                  //   const SizedBox(
                  //       height: 20,
                  //       width: 20,
                  //       child: CircularProgressIndicator(
                  //         color: Colors.white,
                  //       ),
                  //     )
                  //     :
                    Text(
                        'ELIMINAR',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                    )
                //),
              ),
                        ),
            ),
          ),
        ),
      ],
    );
  }
}


class _EventPublicRelationResumeData extends StatefulWidget {
  final JwtAuthenticationResponseDTO session;
  final String publicRelationCode;
  const _EventPublicRelationResumeData({
    super.key,
    required this.session,
    required this.publicRelationCode
  });

  @override
  State<_EventPublicRelationResumeData> createState() => _EventPublicRelationResumeDataState();
}

class _EventPublicRelationResumeDataState extends State<_EventPublicRelationResumeData> {
  late JwtAuthenticationResponseDTO _session;
  late String _publicRelationCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _session = widget.session;
    _publicRelationCode = widget.publicRelationCode;
  }

  Future<EventPublicRelationDataDTO> getPublicRelationResumeData() async {
    EventPublicRelationDataDTO eventData =  await EventPublicRelationsRepositoryImpl(_session).getEventDataResume(_publicRelationCode);
    return eventData;
  }

  @override
  Widget build(BuildContext context) {
    return 
    FutureBuilder(
      future: getPublicRelationResumeData(),
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
          return const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmedDataResumeWidget(icon: Icons.local_activity_outlined),
                ShimmedDataResumeWidget(icon: Icons.local_activity_outlined),
                ShimmedDataResumeWidget(icon: Icons.local_activity_outlined),
              ],
            ),
          );    
        }else{
          EventPublicRelationDataDTO data = snapshot.data as EventPublicRelationDataDTO;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 15.0),
                child: 
                  Row(
                    children: [
                      DataResumeWidget(
                        title: 'VENDIDAS', 
                        value: data.amountSold, 
                        icon: Icons.local_activity_outlined, 
                        iconColor: Theme.of(context).colorScheme.secondary,
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                      const SizedBox(width: 5),
                      DataResumeWidget(
                        title: 'COMISION', 
                        value: '${data.profit}€', 
                        icon: Icons.local_activity_outlined,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                      const SizedBox(width: 5),
                      DataResumeWidget(
                        title: 'INGRESOS', 
                        value: '${data.totalIncome}€', 
                        icon: Icons.euro_outlined,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        color: Theme.of(context).colorScheme.onBackground
                      )
                    ],
                  )
              ),
            ],
          );
        }
      }
    );
  }
}


