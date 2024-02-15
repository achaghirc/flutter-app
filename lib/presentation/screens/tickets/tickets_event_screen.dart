import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_details_dart.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/event_tickets_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/event_tickets_query_params.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/screens/tickets/operations/create_ticket_type_widget.dart';
import 'package:my_app/presentation/screens/tickets/operations/create_ticket_widget.dart';
import 'package:my_app/presentation/screens/tickets/operations/ticket_details_widget.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/custom_painter/wave_custom_painter.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_data_resume_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_tickets.dart';
import 'package:my_app/shared/widgets/tickets/data_resume_widget.dart';
import 'package:shimmer/shimmer.dart';

class TicketsEventScreen extends ConsumerStatefulWidget {
  final EventDTO event;
  const TicketsEventScreen({
    super.key,
    required this.event
  });

  @override
  ConsumerState<TicketsEventScreen> createState() => _TicketsEventScreenState();
}

class _TicketsEventScreenState extends ConsumerState<TicketsEventScreen> {
  late EventDTO _event;
  late JwtAuthenticationResponseDTO session;

  Future<List<EventTicketsDTO>> searchTickets() async{
    try{
      EventTicketsQueryParams queryParams =  EventTicketsQueryParams(eventId: _event.id);
      List<EventTicketsDTO> tickets = await EventTicketsRepositoryImpl(session).search(queryParams);
      return tickets;
    }catch(err) {
      print(err.toString());
    }
    return List.empty();
  }
  Future<EventTicketsDetailsDTO> findTicketDetailsData() async {
    EventTicketsDetailsDTO data = await EventTicketsRepositoryImpl(session).eventTicketsDataResume(_event.id);
    return data;
  }

  Future<void> refreshTickets() async{
    setState(() {});
  }

  
  ImageProvider buildImage() {
    if (_event.medias.isEmpty || _event.medias.first.title == 'Default') { 
      return const AssetImage('assets/santaliaimage.jpg');
    }else{ 
      return MemoryImage(_event.medias.first.data);
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _event = widget.event;
    if(!ref.exists(sessionProvider)){
      context.pushReplacementNamed('signin');
    }
    session = ref.read(sessionProvider).session!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
        title: Text(
          'Entradas',
          style: GoogleFonts.nunito(),
        ),
        actions: const [
          AppBarActions()
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: HeaderWavePainter(context: context),
            ),
          ),
          Column(
            children:[
              FutureBuilder(
                future: findTicketDetailsData(), 
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData ){
                    return Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Theme.of(context).colorScheme.inverseSurface,
                          highlightColor: Theme.of(context).colorScheme.secondary,
                          child: SizedBox(height: 20, width: MediaQuery.of(context).size.width * 0.4,child: Container(decoration: const BoxDecoration(color: Colors.black12))),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmedDataResumeWidget(),
                              ShimmedDataResumeWidget(),
                              ShimmedDataResumeWidget(),
                            ],
                          ),
                        ),
                      ],
                    );            
                  }else {
                    EventTicketsDetailsDTO data = snapshot.data as EventTicketsDetailsDTO;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _event.name,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DataResumeWidget(title: 'VENDIDAS', value: data.amountSold, icon: Icons.local_activity_outlined, color: Colors.white),
                              DataResumeWidget(title: 'RESTANTES', value: '${data.amountRemaining}€', icon: Icons.local_activity_outlined, color: Colors.white),
                              DataResumeWidget(title: 'INGRESOS', value: '${data.totalIncome}€', icon: Icons.euro_outlined, color: Colors.white)
                            ],
                          ),
                        )
                      ],
                    );
                  }
                }
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Detalles',
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => refreshTickets(),
                  child: FutureBuilder(
                    future: searchTickets(), 
                    builder: (context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                        return const ShimmedTicketsList(size: 5);
                      }else{
                        List<EventTicketsDTO> tickets = snapshot.data as List<EventTicketsDTO>;
                        if(tickets.isEmpty){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'No tienes creado ningún conjunto de entradas aún.',
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).colorScheme.onBackground
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Crea las primeras en el icono +',
                                  style: GoogleFonts.nunito(
                                    color: Theme.of(context).colorScheme.onBackground
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.separated(
                          itemCount: tickets.length,
                          separatorBuilder: (context, index) => 
                            const Divider(
                              color: Colors.black12,
                              endIndent: 20.0,
                              indent: 20.0,
                              height: 5,
                            ),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            EventTicketsDTO ticket = tickets.elementAt(index);
                            return ListTile(
                              onTap: () {
                                BottomSheetWidget.showModalBottomSheet(
                                  context,
                                  TicketDetailsWidget(ticket: ticket, event: _event, session: session),
                                  MediaQuery.of(context).size.height * 0.65,
                                  150,
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
                              leading: Icon(
                                Icons.local_activity_outlined,
                                color: ticket.available ? Colors.greenAccent : Theme.of(context).colorScheme.error,
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
                                  ),
                                ],
                              ),
                            );
                          }
                        );
                      }
                    }
                  ),
                ),
              ),
            ]
          ),
          //TICKET TYPE CREATE
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            right: MediaQuery.of(context).size.width * 0.03,
            child: IconButton(
              onPressed: (){
                BottomSheetWidget.showModalBottomSheet(
                  context,
                  const FormCreateTicketType(),
                  MediaQuery.of(context).size.height * 0.5,
                  150,
                  null,
                  null,
                );
              },
              icon: const Icon(
                Icons.settings
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.inversePrimary),
              ),
            )
          ),
          //TICKETS CREATE
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
            child: IconButton(
              onPressed: (){
                BottomSheetWidget.showModalBottomSheet(
                  context,
                  FormCreateTicket(eventId: widget.event.id, eventDate: widget.event.startDate),
                  MediaQuery.of(context).size.height * 0.70,
                  150,
                  null,
                  null,
                );
              },
              icon: const Icon(
                Icons.add
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.inversePrimary),
              ),
            )
          ),
        ],
      )
    );
  }
}








