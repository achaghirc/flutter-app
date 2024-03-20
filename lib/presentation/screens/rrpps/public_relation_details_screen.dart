import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/event_public_relation_data_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/sold_data_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/tickets_search_count_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/tickets_query_params.dart';
import 'package:my_app/infraestructure/repositories/tickets_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/widgets/custom_painter/wave_custom_painter.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_user_event_info.dart';
import 'package:my_app/shared/widgets/tickets/data_resume_widget.dart';

class PublicRelationDetailsScreen extends ConsumerStatefulWidget {
  final String? rrppCode;
  final String? eventId;
  const PublicRelationDetailsScreen({
    super.key,
    required this.eventId,
    required this.rrppCode
  });
   @override
  ConsumerState<PublicRelationDetailsScreen> createState() => _RelationPublicDetailsScreenState();
}
class _RelationPublicDetailsScreenState extends ConsumerState<PublicRelationDetailsScreen> {
  late String? _rrppCode;
  late String? _eventId;
  late JwtAuthenticationResponseDTO session;
  @override
  void initState() {
    super.initState();
    if(ref.read(sessionProvider).session == null){
      context.pushReplacementNamed('signin');
    }
    _rrppCode = widget.rrppCode;
    _eventId = widget.eventId;
    session = ref.read(sessionProvider).session!;
  }
  
  Future<SoldDataDTO> searchTickets() async{
    try{  
      TicketsQueryParams queryParams =  TicketsQueryParams(eventId: int.parse(_eventId!), rrppCode: _rrppCode!);
      SoldDataDTO data = await TicketsRepositoryImpl(session).searchTicketsSold(queryParams);
      return data;
    }catch(err) {
      print(err.toString());
    }
    return SoldDataDTO.fromJson({});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        scrolledUnderElevation: 0.0,
        title: Text(
          'Ventas',
          style: GoogleFonts.nunito(),
        ),
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              onPressed: (){
                context.pushReplacementNamed('event_squad_list',  pathParameters: {'eventId': _eventId.toString()} );
              }, 
              icon: const Icon(Icons.arrow_back)
            );
          }
        ),
        actions: const [
          AppBarActions()
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
            painter: HeaderWavePainter(context: context),
            ),
          ),
          Column(
            children: [
              //Imagen de usuario y datos personales
              Expanded(
                child: FutureBuilder(
                  future: searchTickets(), 
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                      return const ShimmedUserEventInfo(size: 5);                            
                    }else {
                      SoldDataDTO snapdata = snapshot.data as SoldDataDTO;
                      List<TicketSearchCountDTO> tickets = snapdata.ticketsSold;
                      EventPublicRelationDataDTO infoUser = snapdata.data;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                    radius: 25, // Image radius
                                    backgroundImage: AssetImage('assets/userIcons/menProfile.png'),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      infoUser.userPersonName,
                                      style: GoogleFonts.nunito(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color:Colors.white
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      infoUser.userUsername,
                                      style: GoogleFonts.nunito(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color:Colors.white
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DataResumeWidget(
                                  title: 'VENDIDAS', 
                                  value: infoUser.amountSold, 
                                  icon: Icons.local_activity_outlined, 
                                  color: Colors.white, 
                                  iconColor: Theme.of(context).colorScheme.primary
                                ),
                                DataResumeWidget(
                                  title: 'COMISION',
                                  value: '${infoUser.profit}€', 
                                  icon: Icons.local_activity_outlined, 
                                  color: Colors.white, 
                                  iconColor: Theme.of(context).colorScheme.primary
                                ),
                                DataResumeWidget(
                                  title: 'INGRESOS', 
                                  value: '${infoUser.totalIncome}€', 
                                  icon: Icons.euro_outlined, 
                                  color: Colors.white, 
                                  iconColor: Theme.of(context).colorScheme.primary
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Entradas',
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
                          tickets.isNotEmpty ? (
                            _TicketsListWidget(tickets: tickets)
                          )
                          :
                          Container(
                            padding: EdgeInsets.fromLTRB(0.0, MediaQuery.of(context).size.height * 0.03, 0.0, 0.0),
                            alignment: Alignment.center,
                            child: Text(
                              'NO TIENE TICKETS VENDIDOS',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w600
                              ),
                              
                            ),
                          )
                        ],
                      );
                    }
                  }
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _TicketsListWidget extends StatelessWidget {
  final List<TicketSearchCountDTO> tickets;
  const _TicketsListWidget({
    required this.tickets
  });

  @override
  Widget build(BuildContext context) {
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
        TicketSearchCountDTO ticket = tickets.elementAt(index);
        return ListTile(
          onTap: () {
            // BottomSheetWidget.showModalBottomSheet(
            //   context,
            //   TicketDetailsWidget(ticket: ticket, event: _event, session: session),
            //   MediaQuery.of(context).size.height * 0.65,
            //   150,
            //   null,
            //   null,
            // );
          },
          title: Text(
            ticket.ticketsTypeEncoderLocatedCode,
            style: GoogleFonts.nunito(

            ),
          ),
          subtitle: Text(
            ticket.ticketsTypeEncoderName,
            style: GoogleFonts.nunito(
              
            ),
          ),
          leading: const Stack(
            children: [
              Icon(
                Icons.local_activity_outlined,
              ),
            ]
          ),
          trailing: Wrap(
            alignment: WrapAlignment.center,
            spacing: 15,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                radius: 20.0,
                child: Text(
                  '${ticket.eventTicketPrice}€',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
              CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  radius: 20.0,
                  child: Text(
                    'x${ticket.amount}',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight:FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
              )
            ],
          ),
        );
      }
    );
  }
}