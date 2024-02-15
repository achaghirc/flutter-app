import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/repositories/event_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/widgets/cards/card_event.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/navigation/bottom_navigation_widget.dart';
import 'package:my_app/shared/widgets/search/search_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_events.dart';


var session = globals.container.read(sessionProvider).session;


class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  EventScreenState createState() => EventScreenState();
}


class EventScreenState extends ConsumerState<EventsScreen> {
  late JwtAuthenticationResponseDTO? session;
  TextEditingController searchController = TextEditingController();
  late String searchString = '';
  Future<List<EventDTO>> getEvents() async{
    List<EventDTO> events = await EventRepositoryImpl(session).getAllEventsAvailable();
    return events;
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
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Padding(
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
              onTap: () {
              },
          ),
        ),
        titleSpacing: 3,
        actions: const [
          AppBarActions()
        ],
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
                    } else {
                      List<EventDTO> data = snapshot.data as List<EventDTO>;
                      if(searchString.isNotEmpty && data.isNotEmpty){
                        data = data.where((element) => element.name.contains(searchString)).toList();
                      }
                      if(data.isEmpty){
                        return const Center(
                          child: Text('No events available yet'),
                        );
                      }else{
                        return Column(
                          children: [
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () => getEvents(),
                                child: ListView.separated(
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
                                      images: event.medias,
                                      session: session,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
              ),
            ]
          ),
          (session!.user.roleCode == 'ADMIN') ?
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.03,
              right: MediaQuery.of(context).size.width * 0.03,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  fixedSize: const Size.fromHeight(65)
                ),
                onPressed: (){
                  context.pushReplacementNamed('create_event');
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
    );
  }
}