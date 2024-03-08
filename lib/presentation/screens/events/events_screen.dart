import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/custom/event_organizer_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/repositories/event_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/widgets/cards/card_event.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/navigation/bottom_navigation_widget.dart';
import 'package:my_app/shared/widgets/search/search_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_events.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  EventScreenState createState() => EventScreenState();
}


class EventScreenState extends ConsumerState<EventsScreen> {
  late JwtAuthenticationResponseDTO? session;
  TextEditingController searchController = TextEditingController();
  late String searchString = '';
  
  Future<EventOrganizerDTO> getEvents() async{
    if(mounted && session != null){
      EventOrganizerDTO events = await EventRepositoryImpl(session).getAllEventsOrganizer(session!.user.organizerId.first.toString());
      return events;
    }else{
      return EventOrganizerDTO.fromJson({});
    }
  }

  
  @override
  void initState() {
    super.initState();
    if(!ref.exists(sessionProvider) || ref.read(sessionProvider).session == null) {
      context.pushReplacementNamed('signin');
    }
    session = ref.read(sessionProvider).session;
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          leading: const Icon(
            Icons.search_outlined
          ),
          title: FadeIn(
            animate: true,
            duration: const Duration(milliseconds: 350),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                child: SearchWidget(
                    searchController: searchController, 
                    placeholder: 'Buscar eventos', 
                    onChanged: (value) {
                      if(value.length > 2 ){
                        setState(() {
                          searchString = value;                           
                        });
                      }
                    },
                    onTap: () {},
                    onClear: () {
                      setState(() {
                        searchString = "";
                      });
                    },
                ),
              ),
          ),
          titleSpacing: 3,
          actions: const [
            AppBarActions()
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Finalizados"),
              Tab(text: "Activos")
            ]
          ),
        ),
        body: Stack(
          children:[ 
            Column(
              children:[ 
                Expanded(
                  child: FutureBuilder(
                    future: getEvents(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                        return const ShimmedEvents();
                      } else if(snapshot.data == null){
                        return const Center(
                            child: Text('No tienes ningún evento aún, crea el primero'),
                          ); 
                      }else {
                        EventOrganizerDTO data = snapshot.data as EventOrganizerDTO;
                        List<EventDTO> active = data.active;
                        List<EventDTO> finished = data.finished;
                        if(searchString.isNotEmpty && active.isNotEmpty){
                          active = active.where((element) => element.name.toUpperCase().contains(searchString.toUpperCase())).toList();
                        }
                        if(searchString.isNotEmpty && finished.isNotEmpty){
                          finished = finished.where((element) => element.name.toUpperCase().contains(searchString.toUpperCase())).toList();
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () => getEvents(),
                                child: TabBarView(
                                  children: [
                                    EventAdminList(data: finished, session: session!),
                                    EventAdminList(data: active, session: session!)
                                  ]
                                )
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  ),
                ),
              ]
            ),
            (session != null && session!.user.roleCode == 'ADMIN') ?
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.03,
                right: MediaQuery.of(context).size.width * 0.03,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: (){
                    context.pushNamed('create_event');
                  }, 
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.background,
                    )
                  ),
              ) : const SizedBox()
          ],
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(),
      ),
    );
  }
}


class EventAdminList extends StatelessWidget {
  final List<EventDTO> data;
  final JwtAuthenticationResponseDTO session;

  const EventAdminList({
    super.key,
    required this.data,
    required this.session
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemCount: data.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        EventDTO event = data.elementAt(index);
        return CardEvent(
          id: event.id,
          titleCard: event.name, 
          subtitle: event.description, 
          startDate: event.startDate,
          location: '${event.ubicationTypeRoad.toUpperCase()} ${event.ubicationNameRoad}',
          status: event.statusCode,
          images: event.medias,
          session: session,
        );
      },
    );
  }
}