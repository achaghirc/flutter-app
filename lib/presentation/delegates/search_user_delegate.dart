
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/user_info_dto.dart';
import 'package:my_app/infraestructure/models/squad/organizer_squad_dto.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpp.dart';

typedef SearchUsersCallback = Future<List<UserInfoDTO>> Function(String query,String searchType, String organizerId,String? eventId, int page);
typedef AddToSquadUsersCallback = Future<List<OrganizerSquadDTO>> Function(String userId);

class SearchUserDelegate extends SearchDelegate<List<OrganizerSquadDTO>?> {
  final JwtAuthenticationResponseDTO session;
  final SearchUsersCallback searchUsers;
  final AddToSquadUsersCallback addUserToSquad;
  final List<int> actualSquad;
  late List<OrganizerSquadDTO> resultSquadList = [];


  SearchUserDelegate({
    required this.addUserToSquad,
    required this.searchUsers,
    required this.session,
    required this.actualSquad
  });

  @override
  String get searchFieldLabel => 'Buscar usuarios';

  Future<List<UserInfoDTO>> getUsers() async {
    var searchType = query == '' ? "OrganizerSuggestions" : "UsernameAndOrganizer";
    List<UserInfoDTO> users = await searchUsers(query, searchType , session.user.organizerId.first, null, 0);
    return users;
  }

  Future<List<OrganizerSquadDTO>> addUserToSquadCall(UserInfoDTO user) async {
    List<OrganizerSquadDTO> squad = await addUserToSquad(user.id);
    resultSquadList = squad;
    return squad;
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
        if(!snapshot.hasData) {
          return const Center(
            child: Text(
              'No coincide con ningún usuario'
            ),
          );
        }else {
          var users = snapshot.data ?? [];
          return ListView.separated(
            separatorBuilder:  (context, index) => 
              const Divider(
                color: Colors.black12,
                endIndent: 20.0,
                indent: 20.0,
                height: 20,
              ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserItem(user: user, addUserToSquadCall: addUserToSquadCall, actualSquad: actualSquad);
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
        'Type and search for a new RRPP'
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

class _UserItem extends StatefulWidget {
  const _UserItem({
    required this.user, 
    required this.addUserToSquadCall,
    required this.actualSquad,
  });

  final List<int> actualSquad;
  final UserInfoDTO user;
  final Function addUserToSquadCall;

  @override
  State<_UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<_UserItem> {
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
          widget.user.username,
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
              actualSquad.contains(int.parse(widget.user.id)) ?
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
                    widget.addUserToSquadCall(widget.user).then((res) {
                      actualSquad.add(int.parse(widget.user.id));
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