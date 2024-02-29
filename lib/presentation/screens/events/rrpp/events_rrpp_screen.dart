import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/custom/event_code_dto.dart';
import 'package:my_app/infraestructure/models/events/custom/event_data_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/repositories/event_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/event_query_params.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/widgets/cards/card_event.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/navigation/bottom_navigation_widget.dart';
import 'package:my_app/shared/widgets/search/search_widget.dart';

typedef SearchEvents = Future<EventDataDTO> Function();

class EventRRPPsScreen extends ConsumerStatefulWidget {
  const EventRRPPsScreen({super.key});
  
  @override
  ConsumerState<EventRRPPsScreen> createState() => _EventRRPPsScreenState();
}

class _EventRRPPsScreenState extends ConsumerState<EventRRPPsScreen> {

  TextEditingController searchController = TextEditingController();
  List<EventDTO> allEvents = [];
  List<EventDTO> fixedAllEvents = [];
  List<EventCodeDTO> assignedEvents = [];
  List<EventCodeDTO> fixedAssignedEvents = [];
  late JwtAuthenticationResponseDTO session;
  late bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if(ref.read(sessionProvider).session == null){
      context.pushReplacementNamed("signin");
    }
    session = ref.read(sessionProvider).session!;
    searchEvents().then((result) => {
       setState(() {
        isLoading = false;
        allEvents = result.allEvents;
        assignedEvents = result.assignedEvents;
        fixedAllEvents = allEvents;
        fixedAssignedEvents = assignedEvents;
      })
    });
  }

  Future<EventDataDTO> searchEvents() async{
    setState(() {
      isLoading = true;
    });
    EventQueryParams eventQueryParams = EventQueryParams();
    EventDataDTO result = await EventRepositoryImpl(session).search(eventQueryParams);
    return result;
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          title: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: SearchWidget(
              searchController: searchController, 
              placeholder: 'Buscar Eventos', 
              onChanged: (value){
                if(value == ""){
                  allEvents = fixedAllEvents;
                  assignedEvents = fixedAssignedEvents;
                }else{
                  allEvents = fixedAllEvents.where((element) => element.name.toUpperCase().contains(value.toUpperCase())).toList();
                  assignedEvents = fixedAssignedEvents.where((element) => element.eventName.toUpperCase().contains(value.toUpperCase())).toList();
                }              
                setState(() {});
              },
              onTap: (){}  
            ),
          ),
          titleSpacing: 3,
          actions: const [
            AppBarActions()
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Tus Eventos"),
              Tab(text: "Restantes")
            ]
          ),
        ),
        body: TabBarView(
          children: [
            isLoading ? const Center(child: CircularProgressIndicator(),) : _YourRRPPEvents(events: assignedEvents, session: session),
            isLoading ? const Center(child: CircularProgressIndicator(),) : _RestOfEvents(events: allEvents, session: session),                    
          ]
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(),
        )
      );
  }
}


class _YourRRPPEvents extends StatelessWidget {
  final List<EventCodeDTO> events;
  final JwtAuthenticationResponseDTO session;
  const _YourRRPPEvents({
    required this.events,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    if(events.isEmpty) {
      return Center(
        child: Text(
          'No hay enventos',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.inverseSurface
          ),
        ),
      );
    }else{
      return ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: events.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {    
            EventCodeDTO eventCode = events.elementAt(index);
            return CardEvent(
              id: eventCode.eventId,
              titleCard: eventCode.eventName, 
              subtitle: eventCode.eventDescription, 
              startDate: eventCode.eventStartDate,
              location: '${eventCode.eventUbicationTypeRoad.toUpperCase()} ${eventCode.eventUbicationNameRoad}',
              images: eventCode.eventMedias,
              rrppCode: eventCode.rrppCode,
              session: session,
            );  
          }
      );
    }
  }
}
class _RestOfEvents extends StatelessWidget {
  final List<EventDTO> events;
  final JwtAuthenticationResponseDTO session;
  const _RestOfEvents({
    required this.events,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    if(events.isEmpty) {
      return Center(
        child: Text(
          'No hay enventos',
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.inverseSurface
          ),
        ),
      );
    }else{
      return ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: events.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {    
            EventDTO event = events.elementAt(index);
            return CardEvent(
              id: event.id,
              titleCard: event.name, 
              subtitle: event.description, 
              startDate: event.startDate,
              location: '${event.ubicationTypeRoad.toUpperCase()} ${event.ubicationNameRoad}',
              images: event.medias,
              session: session,
            );  
          }
      );
    }
  }
}



