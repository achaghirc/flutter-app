import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';



class BottomNavigationBarWidget extends ConsumerStatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  ConsumerState<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends ConsumerState<BottomNavigationBarWidget> {
  late JwtAuthenticationResponseDTO? session;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session = ref.read(sessionProvider).session;

    if(session == null){
      context.go('/signin');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


    int getCurrentIndexPage(BuildContext context) {
      final String location = GoRouterState.of(context).matchedLocation;
      
       if(session!.user.roleCode == 'USER'){
        switch(location){
          case '/homeUser':
            return 0;
          case '/tickets':
            return 1;
          default:
            return 0;
        }
      } else if(session!.user.roleCode == 'ADMIN') {
        switch(location){
          case '/myrrpps':
            return 0;
          case '/home':
            return 1;
          default:
            return 0;
        }
      } else {
        switch(location){
          case '/rrppZone':
            return 0;
          case '/homeRRPP':
            return 1;
          case '/tickets':
            return 2;
          default:
            return 1;
        }
      }
    }


    void onItemTapped(BuildContext context, int index) {
      if(session!.user.roleCode == 'USER'){
        switch(index){
          case 0:
            context.pushNamed('event_home_user');
            break;
          case 1: 
            context.pushNamed('tickets_user_screen');
            break;
        }
      }else if(session!.user.roleCode == "ADMIN") {
        switch(index) {
          case 0:
            context.pushReplacement('/myrrpps');
            break;
          case 1: 
            context.pushReplacementNamed('event_home');      
            break;
          case 2:
          context.pushReplacementNamed('tickets_user_screen');
          break;
        }
      }else {
        switch(index) {
          case 0:
            context.push('/rrppZone'); 
            break;
          case 1: 
            context.pushNamed('event_home_rrpp');
            break;
          case 2:
            context.pushNamed('tickets_user_screen');
            break;
        }
      }
    }

  List<BottomNavigationBarItem> getBottonNavigationByRole() {
    List<BottomNavigationBarItem> items = [];
    if(session!.user.roleCode == 'ADMIN'){
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.groups_2_outlined,
          ),
          label: '',
      ),
      );
      items.add(
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.nightlife_outlined,
            ),
            label: ''
          ),
      );
    }else if(session!.user.roleCode == 'RRPP') {
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.groups_2_outlined
          ),
          label: '',
        )
      );
      items.add(
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.nightlife_outlined,
            ),
            label: '',
          ),
      );
      items.add(
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.local_activity_outlined,
          ),
          label: '',
        ),
      );
    }else if(session!.user.roleCode == 'USER'){
       items.add(
        const BottomNavigationBarItem(
            icon: Icon(
              Icons.nightlife_outlined,
            ),
            label: '',
          ),
      );
      items.add(
      const BottomNavigationBarItem(
          icon: Icon(
            Icons.local_activity_outlined,
          ),
          label: '',
        ),
    );
    }
   
    return items;
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 25,
      selectedFontSize: 12,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.secondary, 
        size: 30,
        fill: 0.80,
      ),
      enableFeedback: true,
      elevation: 2,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).colorScheme.inverseSurface,
      items: getBottonNavigationByRole(),
      currentIndex: getCurrentIndexPage(context),
      onTap: (index) {
        onItemTapped(context, index);
      }
    );
  }
}