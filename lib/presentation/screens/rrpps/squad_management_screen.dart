import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/user_info_dto.dart';
import 'package:my_app/infraestructure/models/squad/organizer_squad_dto.dart';
import 'package:my_app/infraestructure/repositories/organizer_squad_respository_impl.dart';
import 'package:my_app/infraestructure/repositories/user_repository_impl.dart';
import 'package:my_app/presentation/delegates/search_user_delegate.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/navigation/bottom_navigation_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpp.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpps_list.dart';
import 'package:my_app/shared/widgets/search/search_widget.dart';




class SquadManagementScreen extends ConsumerStatefulWidget {
  const SquadManagementScreen({super.key});

  @override
  ConsumerState<SquadManagementScreen> createState() => _SquadManagementScreenState();
}

class _SquadManagementScreenState extends ConsumerState<SquadManagementScreen> { 
  String searchString = "";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late List<OrganizerSquadDTO> squadList = [];
  TextEditingController searchController = TextEditingController();
  late Future<void> initSquadData;
  late JwtAuthenticationResponseDTO session;
  late bool showCircularProgress = false;
  late bool showAddUserCircularProgress = false;
  void openDialog( BuildContext context, int userId, int organizerId) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(
          'Eliminar',
          style: GoogleFonts.nunito(),
        ),
        content: Text(
          '¿Estas seguro de que quieres eliminar este RRPP de tu Squad?',
          style: GoogleFonts.nunito()
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
          FilledButton(onPressed: () => deleteUserFromSquad(context, userId, organizerId), child: const Text('Aceptar'))
        ],
      ),
    );

  }


  Future<void> deleteUserFromSquad( BuildContext context, int userId, int organizerId) async{
    setState(() {
      showCircularProgress = true;
    });
    context.pop();
    squadList.removeWhere((user) => user.userId == userId);
    setState(() {
      squadList = squadList;
      showCircularProgress = false;
    });
    await OrganizerSquadRepositoryImpl(session).deleteUserFromSquad(userId, organizerId);
  }


  Future<List<OrganizerSquadDTO>> getSquadTeam({String? value}) async{
    if(squadList.isEmpty && searchString == ''){
      List<OrganizerSquadDTO> listSquadResponse = 
      await OrganizerSquadRepositoryImpl(session)
        .getTeamSquadByOrganizer(session.user.organizerId.first);
      return listSquadResponse;
    }
    return squadList;
  }

  Future<void> _refreshSquadList() async {
    List<OrganizerSquadDTO> listSquadResponse = await OrganizerSquadRepositoryImpl(session)
      .getTeamSquadByOrganizer(session.user.organizerId.first);
    setState(() {
      squadList = listSquadResponse;
    });  
  }

  Future<void> addUserToUserSquad(UserInfoDTO user) async {
    List<OrganizerSquadDTO> listSquadResponse = await OrganizerSquadRepositoryImpl(session)
      .addUserToSquad(user.id);
    setState(() {
      squadList = listSquadResponse;
    });  
  }

  @override
  void initState() {
    super.initState();
    if(!ref.exists(sessionProvider) || ref.read(sessionProvider).session == null ) {
      context.pushReplacementNamed('signin');
    }else {
      searchController.addListener(_onSearchChanged);
      session = ref.read(sessionProvider).session!;
      initSquadData = getSquadTeam();
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
        title: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: SearchWidget(
              searchController: searchController, 
              placeholder: 'Buscar en Squad', 
              onClear: () {
                searchString = "";
                searchController.text = "";
                setState(() {});
              },
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
        titleSpacing: 1,
        actions: const [
          AppBarActions()
        ],
      ),
      body: 
      showAddUserCircularProgress ? 
      Stack(
        children: [
          ShimmedRRPPSList(size: squadList.length < 10 ? squadList.length + 1 : 10),
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
                  future: getSquadTeam(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                      return ShimmedRRPPSList(size: squadList.isEmpty ? 9 :  squadList.length );
                    } else {
                      List<OrganizerSquadDTO> data = snapshot.data as List<OrganizerSquadDTO>;
                      if(searchController.text.length > 2 ){
                        data = data.where((element) => element.userUsername.toUpperCase().contains(searchString.toUpperCase())).toList();
                      }
                      if(data.isEmpty && searchString == ''){
                        return const Center(
                          child: Text('Add your first member!'),
                        );
                      }else {
                        getSquadTeam();
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              key: _refreshIndicatorKey,
                              onRefresh: _refreshSquadList,
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
                                  OrganizerSquadDTO user = data.elementAt(index);
                                  if(showCircularProgress) {
                                    return const ShimmedRRPP();
                                  }else{  
                                    return ListTile(
                                      title: Text(user.userPersonName),
                                      subtitle: Text(user.userUsername),
                                      leading: const CircleAvatar(
                                        radius: 25, // Image radius
                                        backgroundImage: AssetImage('assets/userIcons/menProfile.png'),
                                      ),
                                      trailing: Wrap(
                                        spacing: 5,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              openDialog(context, user.userId, user.organizerId);
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
                backgroundColor: Theme.of(context).colorScheme.secondary
              ),
              onPressed: (){
                final session = ref.read(sessionProvider).session!;
                showSearch<List<OrganizerSquadDTO>?>(
                  context: context,
                  delegate: SearchUserDelegate(
                    searchUsers: UserRepositoryImpl(session).getUsersByUsernamePageable,
                    addUserToSquad: OrganizerSquadRepositoryImpl(session).addUserToSquad,
                    session: session,
                    actualSquad: squadList.map((e) => e.userId).toList(),
                  )
                ).then((organizerSquad) {
                  if(organizerSquad == null) return null;
                  if(organizerSquad.isEmpty) return null;
                  setState(() {
                    squadList = organizerSquad;
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
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}