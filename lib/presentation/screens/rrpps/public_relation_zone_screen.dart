import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/squad/organizer_squad_dto.dart';
import 'package:my_app/infraestructure/models/squad/public_relation_squad_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/event_public_relation_data_dto.dart';
import 'package:my_app/infraestructure/repositories/event_public_relations_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/organizer_squad_respository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/custom_painter/wave_custom_painter.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/navigation/bottom_navigation_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpps_list.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_user_event_info.dart';
import 'package:my_app/shared/widgets/tickets/data_resume_widget.dart';

class PublicRelationZone extends ConsumerStatefulWidget {
  const PublicRelationZone({super.key});

  @override
  ConsumerState<PublicRelationZone> createState() => _PublicRelationZoneState();
}

class _PublicRelationZoneState extends ConsumerState<PublicRelationZone> {
  late JwtAuthenticationResponseDTO session;
  
  @override
  void initState() {
    super.initState();
    if(ref.read(sessionProvider).session == null){
      context.pushReplacementNamed('signin');
    }
    session = ref.read(sessionProvider).session!;
  }


  Future<EventPublicRelationDataDTO> publicRelationZoneData() async{
    EventPublicRelationDataDTO result = await EventPublicRelationsRepositoryImpl(session).getPublicRelationZoneData();
    return result;
  }

  Future<List<PublicRelationSquadDTO>> publicRelationSquads() async{
    List<PublicRelationSquadDTO> squads = await OrganizerSquadRepositoryImpl(session).getSquads();
    return squads;
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        scrolledUnderElevation: 0.0,
          actions: const [
            AppBarActions()
          ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
              painter: HeaderWavePainter(context: context),
              ),
            ),
            Column(
              children: [
              FutureBuilder(
                future: publicRelationZoneData(), 
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                    return const ShimmedUserEventInfo(size: 0);
                  }else{
                    EventPublicRelationDataDTO data = snapshot.data as EventPublicRelationDataDTO;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0,5.0),
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
                                    session.user.personName,
                                    style: GoogleFonts.nunito(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color:Theme.of(context).colorScheme.surface
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    session.user.username,
                                    style: GoogleFonts.nunito(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color:Theme.of(context).colorScheme.surface
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height:  MediaQuery.of(context).size.height * 0.015,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DataResumeWidget(
                                title: 'EVENTOS', 
                                value: data.totalEvents,  
                                icon: Icons.event_available_outlined, 
                                color: Colors.white, 
                                iconColor: Theme.of(context).colorScheme.primary
                              ),
                              DataResumeWidget(
                                title: 'CARTERA', 
                                value: '${data.profit}', 
                                icon: Icons.account_balance_wallet_outlined, 
                                color: Colors.white, 
                                iconColor: Theme.of(context).colorScheme.primary
                              ),
                              DataResumeWidget(
                                title: 'PUNTUACIÓN', 
                                value: '4.9/5',
                                icon: Icons.star_border_purple500_outlined, 
                                color: Colors.white, 
                                iconColor: Theme.of(context).colorScheme.primary
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
              ),
              SizedBox(height:MediaQuery.of(context).size.height * 0.06),
              Container(
                padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Equipos',
                  style: GoogleFonts.nunito(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 20,
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
                child: FutureBuilder(
                    future: publicRelationSquads(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                        return const ShimmedRRPPSList(size: 3);
                      } else if(snapshot.data == null) {
                        return Center(
                          child: Text(
                            'No perteneces a ningún equipo aún',
                            style: GoogleFonts.nunito(),
                          ),
                        );
                      }else{
                      List<PublicRelationSquadDTO> squads = snapshot.data as List<PublicRelationSquadDTO>;
                      return ListView.separated(
                        itemCount: squads.length,
                        separatorBuilder: (context, index) => 
                          const Divider(
                            color: Colors.black12,
                            endIndent: 20.0,
                            indent: 20.0,
                            height: 5,
                          ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          PublicRelationSquadDTO squad = squads.elementAt(index);
                          return ListTile(
                            onTap: () {
                              BottomSheetWidget.showModalBottomSheet(
                                context,
                                _TeamOrganizerDetails(squad:squad),
                                MediaQuery.of(context).size.height * 0.45,
                                150,
                                null,
                                BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                  color: Theme.of(context).colorScheme.surface
                                ),
                              );
                            },
                            title: Text(
                              squad.organizer.name.toUpperCase(),
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            subtitle: Text(
                              squad.organizerSquad.userUsername,
                              style: GoogleFonts.nunito(
                                
                              ),
                            ),
                            leading: const Icon(
                              Icons.groups_2_outlined
                            ),
                            trailing: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 15,
                              children: [
                                Icon(
                                  squad.eventSummary.active > 0 ? Icons.check_circle_outline_outlined : Icons.close_outlined,
                                  color: squad.eventSummary.active > 0 ?Colors.greenAccent : Colors.redAccent,
                                )
                              ],
                            ),
                          );
                        }
                      );
                      }
                    } ,
                )
              ),
              ],
            )
          ],
        )
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}

class _TeamOrganizerDetails extends StatelessWidget {
  final PublicRelationSquadDTO squad;
  const _TeamOrganizerDetails({
    super.key,
    required this.squad
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Text(
          squad.organizer.name,
          style: GoogleFonts.nunito(
            fontSize: 35,
            fontWeight: FontWeight.bold
          ),
        ),
        ListTile(
          leading: const CircleAvatar(
            radius: 25, // Image radius
            backgroundImage: AssetImage('assets/userIcons/menProfile.png'),
          ),
          title: Text(
            squad.organizerSquad.userPersonName,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w700
            ),
          ),
          subtitle: Text(
            squad.organizerSquad.userUsername,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
          ),
          trailing: Wrap(
            children: [
              Text(
                'Admin',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              )
            ]
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              Icons.groups_2_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          title: Text(
            'Integrantes',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w700
            ),
          ),
          trailing: Wrap(
            children: [
              Text(
                '${squad.organizer.totalMembers}',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              )
            ]
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              Icons.event_note_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          title: Text(
            'Eventos asignados',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w700
            ),
          ),
          trailing: Wrap(
            children: [
              Text(
                '${squad.eventSummary.total}',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              )
            ]
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              Icons.event_available_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          title: Text(
            'Eventos activos',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w700
            ),
          ),
          trailing: Wrap(
            children: [
              Text(
                '${squad.eventSummary.active}',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              )
            ]
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          onPressed: (){}, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primary
          ),
          child: Text(
            'ABANDONAR',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          )
        )
      ],
    );
  }
}