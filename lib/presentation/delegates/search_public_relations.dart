
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/user_info_dto.dart';
import 'package:my_app/infraestructure/models/squad/event_public_relations_dto.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpp.dart';

typedef SearchUsersCallback = Future<List<UserInfoDTO>> Function(String query,String searchType, String organizerId, String? eventId, int page);
typedef AddToPublicRelationsCallback = Future<List<EventPublicRelationsDTO>> Function(String userId, String eventId);

class SearchPublicRelationsDelegate extends SearchDelegate<List<EventPublicRelationsDTO>?> {
  final String eventId;
  final SearchUsersCallback searchUsers;
  final AddToPublicRelationsCallback addPublicRelationToEventCallback;
  final List<int> actualSquad;
  final JwtAuthenticationResponseDTO session;
  late List<EventPublicRelationsDTO> resultSquadList = [];


  SearchPublicRelationsDelegate({
    required this.addPublicRelationToEventCallback,
    required this.searchUsers,
    required this.eventId,
    required this.actualSquad,
    required this.session
  });

  @override
  String get searchFieldLabel => 'Buscar usuarios';

  Future<List<UserInfoDTO>> getUsers() async {
    var searchType = query == '' ? "AvailableEventRRPP" : "AvailableEventRRPP";
    List<UserInfoDTO> users = await searchUsers(query , searchType,session.user.organizerId.first, eventId, 0);
    return users;
  }

  Future<List<EventPublicRelationsDTO>> addPublicRelationToEventCall(String userId, String eventId) async {
    List<EventPublicRelationsDTO> squad = await addPublicRelationToEventCallback(userId, eventId);
    resultSquadList = squad;
    return resultSquadList;
  }


  @override
  List<Widget>? buildActions(BuildContext context) {
    return  [
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          onPressed: () => query = '', 
          icon: const Icon(Icons.clear)
        ),
      ),
      IconButton(
        onPressed: () => showResults(context), 
        icon: const Icon(Icons.search)
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, resultSquadList), 
      icon: const Icon(Icons.arrow_back_outlined)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              textAlign: TextAlign.center,
              'Lo sentimos no coincide con ninguno de tus relaciones públicas disponibles. Añadelo a tu equipo.'
            ),
          );
        }else {
          var publicRelationsList = snapshot.data ?? [];
          return ListView.separated(
            separatorBuilder:  (context, index) => 
              const Divider(
                color: Colors.black12,
                endIndent: 20.0,
                indent: 20.0,
                height: 20,
              ),
            itemCount: publicRelationsList.length,
            itemBuilder: (context, index) {
              final usersPublicRelations = publicRelationsList[index];
              return _PublicRelationsItem(
                userPublicRelations: usersPublicRelations, 
                addPublicRelationToEventCall: addPublicRelationToEventCall, 
                actualSquad: actualSquad,
                eventId: eventId,
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {    
    return const Center(
      child: Text(
        'Comienza a buscar'
      ),
    );
    // return FutureBuilder(
    //   future: getUsers(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     if(!snapshot.hasData) {
    //       return const Center(
    //         child: Text(
    //           'No coincide con ningún usuario'
    //         ),
    //       );
    //     }
    //     final users = snapshot.data ?? [];
    //     return ListView.separated(
    //       separatorBuilder:  (context, index) => 
    //         const Divider(
    //           color: Colors.black12,
    //           endIndent: 20.0,
    //           indent: 20.0,
    //           height: 20.0,
    //         ),
    //       itemCount: users.length,
    //       itemBuilder: (context, index) {
    //         final user = users[index];
    //         return _UserItem(
    //           user: user,
    //           onUserSelected: close,
    //           addUserToSquadCall: addUserToSquadCall,
    //         );
    //       },
    //     );
    //   },
    // );
  }

}

class _PublicRelationsItem extends StatefulWidget {
  const _PublicRelationsItem({
    required this.eventId,
    required this.userPublicRelations, 
    required this.addPublicRelationToEventCall,
    required this.actualSquad,
  });
  final String eventId;
  final List<int> actualSquad;
  final UserInfoDTO userPublicRelations;
  final Function addPublicRelationToEventCall;

  @override
  State<_PublicRelationsItem> createState() => _PublicRelationsItemState();
}

class _PublicRelationsItemState extends State<_PublicRelationsItem> {
  late List<int> actualSquad;
  late bool showSimmed;

  @override
  void initState() {
    super.initState();
    showSimmed = false;
    actualSquad = widget.actualSquad;
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: 
      showSimmed ? 
      const ShimmedRRPP()
      :
      ListTile(
        title: Text(
          widget.userPublicRelations.username,
          style: GoogleFonts.nunito(
          ),
        ),
        leading: const CircleAvatar(
            radius: 25, // Image radius
            backgroundImage: AssetImage('assets/userIcons/menProfile.png'),
          ),
          trailing: Wrap(
            spacing: 5,
            children: [
              actualSquad.contains(int.tryParse(widget.userPublicRelations.id)) ?
                IconButton(
                  onPressed: () {
                  },
                  icon: 
                  const Icon(
                      Icons.check_circle_outline,
                    ),
                    color: Colors.green,
                )
              :
                IconButton(
                  onPressed: () {
                    setState(() {
                      showSimmed = true;
                    });
                    widget.addPublicRelationToEventCall(widget.userPublicRelations.id, widget.eventId).then((res) {
                      actualSquad.add(int.parse(widget.userPublicRelations.id));
                      setState(() {
                        showSimmed = false;
                      });
                    });
                  },
                  icon: 
                    const Icon(
                      Icons.add_circle_outline_outlined,
                    ),
                    color: Theme.of(context).iconTheme.color,
                )                
            ],
          ),
      ),
    );
  }
}