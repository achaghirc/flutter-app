import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/squad/event_public_relations_dto.dart';
import 'package:my_app/infraestructure/repositories/event_public_relations_repository_impl.dart';
import 'package:my_app/presentation/delegates/search_public_relations.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/providers/events/event_pub_rel_repository_provider.dart';
import 'package:my_app/presentation/providers/users/user_repository_provider.dart';
import 'package:my_app/presentation/screens/events/admin/events_screen_details.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/search/search_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpp.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpps_list.dart';

class SquadEventAssignedScreen extends ConsumerStatefulWidget {
  final String? eventId;
  const SquadEventAssignedScreen({
    super.key,
    required this.eventId
    });

  @override
  ConsumerState<SquadEventAssignedScreen> createState() => _SquadEventAssignedStateScreen();
}

class _SquadEventAssignedStateScreen extends ConsumerState<SquadEventAssignedScreen> {
  late String _eventId;
  String searchString = "";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late List<EventPublicRelationsDTO> publicRelationsList = [];
  TextEditingController searchController = TextEditingController();
  late Future<void> initPublicRelationsData;
  late JwtAuthenticationResponseDTO session;
  late bool showCircularProgress = false;
  late bool showAddUserCircularProgress = false;
  void openDialog( BuildContext context, int id, int eventId) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(
          'Eliminar',
          style: GoogleFonts.nunito(),
        ),
        content: Text(
          '¿Estas seguro de que quieres eliminar este RRPP del evento?',
          style: GoogleFonts.nunito()
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => deletePublicRelationsFromEvent(context, id, eventId), 
            child: const Text('Aceptar')
          )
        ],
      ),
    );
  }

  ///Receives the context, the public relations entity id and the event id to make a logical delete on database.
  Future<void> deletePublicRelationsFromEvent(BuildContext context, int id, int eventId) async{
    setState(() {
      showCircularProgress = true;
    });
    context.pop();
    publicRelationsList.removeWhere((publicRelation) => publicRelation.id == id);
    setState(() {
      publicRelationsList = publicRelationsList;
      showCircularProgress = false;
    });
    await EventPublicRelationsRepositoryImpl(session).deleteFromEvent(id, eventId);
  }


  Future<List<EventPublicRelationsDTO>> searchActivePublicRelationsForEvent() async{
    if(publicRelationsList.isEmpty && searchString == ''){
       List<EventPublicRelationsDTO> publicRelationsDBList = 
      await EventPublicRelationsRepositoryImpl(session).getAllPublicRelationdByEventId(_eventId);
      publicRelationsList = publicRelationsDBList;
    }
    return publicRelationsList;
  }

  Future<void> _refreshPublicRelationsList() async {
     List<EventPublicRelationsDTO> publicRelationsDBList = await EventPublicRelationsRepositoryImpl(session).getAllPublicRelationdByEventId(_eventId);
     setState(() {
       publicRelationsList = publicRelationsDBList;
     });  
  }

  @override
  void initState() {
    super.initState();
    if(!ref.exists(sessionProvider) || ref.read(sessionProvider).session == null ) {
      context.go('signin');
    }else {
      _eventId = widget.eventId ?? '';
      searchController.addListener(_onSearchChanged);
      session = ref.read(sessionProvider).session!;
      initPublicRelationsData = searchActivePublicRelationsForEvent();
    }
  }
  _onSearchChanged(){
    setState(() {    
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: SearchWidget(
            searchController: searchController, 
            placeholder: 'Buscar', 
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
        titleSpacing: 1,
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              onPressed: (){
                context.pushReplacementNamed("event_details", pathParameters: {'id': _eventId.toString(), 'publicRelationCode': 'ADMIN', 'assigned': 'N'});
              }, 
              icon: const Icon(Icons.arrow_back)
            );
          }
        ),
        actions: const [
          AppBarActions()
        ],
      ),
      body: 
      showAddUserCircularProgress ? 
      Stack(
        children: [
          ShimmedRRPPSList(size: publicRelationsList.length < 10 ? publicRelationsList.length + 1 : 10),
          const Center(child: CircularProgressIndicator(),),
        ],
      )      
      :
      Stack(
        children: [
          Column(
              children: [
              Expanded(
                child: FutureBuilder(
                  future: searchActivePublicRelationsForEvent(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                      return ShimmedRRPPSList(size: publicRelationsList.isEmpty ? 9 :  publicRelationsList.length );
                    } else {
                      List<EventPublicRelationsDTO> data = snapshot.data as List<EventPublicRelationsDTO>;
                      if(searchController.text.length > 2 ){
                        data = data.where((element) => element.userUsername.contains(searchString)).toList();
                      }
                      if(data.isEmpty && searchString == ''){
                        return const Center(
                          child: Text('Add your first public relations!'),
                        );
                      }else {
                        searchActivePublicRelationsForEvent();
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              key: _refreshIndicatorKey,
                              onRefresh: _refreshPublicRelationsList,
                              child: ListView.separated(
                                itemCount: data.length,
                                separatorBuilder: (context, index) => 
                                const Divider(
                                  color: Colors.black12,
                                  endIndent: 20.0,
                                  indent: 20.0,
                                  height: 5,
                                ),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  EventPublicRelationsDTO publicRelation = data.elementAt(index);
                                  if(showCircularProgress) {
                                    return const ShimmedRRPP();
                                  }else{  
                                    return ListTile(
                                      onTap: () {
                                        context.pushReplacementNamed('public_relations_details', pathParameters: {"rrppCode": publicRelation.rrppCode, "eventId": _eventId});
                                      },
                                      title: Text(publicRelation.userPersonName),
                                      subtitle: Text(publicRelation.userUsername),
                                      leading: const CircleAvatar(
                                        radius: 25, // Image radius
                                        backgroundImage: AssetImage('assets/userIcons/menProfile.png'),
                                      ),
                                      trailing: Wrap(
                                        spacing: 5,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              openDialog(context, publicRelation.id, publicRelation.eventId);
                                            },
                                            icon: const Icon(Icons.highlight_remove_outlined),
                                            color: Theme.of(context).iconTheme.color,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary
              ),
              onPressed: (){
                final eventPublicRelationsProvider = ref.read(eventPublicRleationsRepositoryProvider);
                final userRepoProvider = ref.read(userRepositoryProvider);
                final session = ref.read(sessionProvider).session!;
                showSearch<List<EventPublicRelationsDTO>?>(
                  context: context, 
                  delegate: SearchPublicRelationsDelegate(
                    searchUsers: userRepoProvider.getUsersByUsernamePageable,
                    addPublicRelationToEventCallback: eventPublicRelationsProvider.assignToEvent,
                    eventId: _eventId,
                    session: session,
                    actualSquad: publicRelationsList.map((e) => e.userId).toList(),
                  )
                ).then((publicRelationsDBList) {
                  if(publicRelationsDBList == null) return null;
                  if(publicRelationsDBList.isEmpty) return null;
                  setState(() {
                    publicRelationsList = publicRelationsDBList;
                  });
                });
              }, 
              child: Icon(
                Icons.person_add_alt,
                color: Theme.of(context).colorScheme.background,
                )
              ),
            )
        ]
      )
    );
  }
}