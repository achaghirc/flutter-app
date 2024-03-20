import 'package:go_router/go_router.dart';
import 'package:my_app/presentation/screens/screens.dart';

final router = GoRouter(
  //initialLocation: FirebaseAuth.instance.currentUser == null ? '/' : '/myevents',
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'entry',
      builder: (context, state) => const EntryScreen(),  
    ),
    GoRoute(
      path: '/signin',
      name: 'signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'event_home',
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: '/homeRRPP',
      name: 'event_home_rrpp',
      builder: (context, state) => const EventRRPPsScreen(),
    ),
    GoRoute(
      path: '/homeUser',
      name: 'event_home_user',
      builder: (context, state) => const EventScreenUserState(),
    ),
    GoRoute(
      path: '/myrrpps',
      name: 'squad_management_screen',
      builder: (context, state) => const SquadManagementScreen(),
    ),
    GoRoute(
      path: '/tickets',
      name: 'tickets_user_screen',
      builder: (context, state) => const TicketsUserScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: '/profile',
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/rrppZone',
      name: 'rrppZone',
      builder: (context, state) => const PublicRelationZone()
    ),
    GoRoute(
      path: '/event/create',
      name: 'create_event',
      builder: (context, state) => const CreateEvent() 
    ),
    GoRoute(
      path: '/event/squad/:eventId',
      name: 'event_squad_list',
      builder: (context, state) => SquadEventAssignedScreen(
        eventId: state.pathParameters['eventId']
      ) 
    ),
    GoRoute(
      path: '/event/squad/rrpp/:rrppCode/:eventId',
      name: 'public_relations_details',
      builder: (context, state) => PublicRelationDetailsScreen(
        eventId: state.pathParameters['eventId'],
        rrppCode: state.pathParameters['rrppCode']
      ) 
    ),
    GoRoute(
      path: '/event/:id/:publicRelationCode/:assigned',
      name: 'event_details',
      builder: (context, state) => EventsScreenDetails(
        id: state.pathParameters['id'],
        publicRelationCode: state.pathParameters['publicRelationCode'],
        assigned: state.pathParameters['assigned'],
      ) 
    ),
    GoRoute(
      path: '/open/event/:id/:publicRelationCode',
      name: 'open_event_details',
      builder: (context, state) => OpenEventDetailsScreen(
        id: state.pathParameters['id'],
        publicRelationCode: state.pathParameters['publicRelationCode'],
      ),
    ),
    GoRoute(
      path: '/payment',
      name: 'payment_methods',
      builder: (context, state) => const PaymentMethods()
    ),
    GoRoute(
      path: '/admin_payment',
      name: 'admin_payment_methods',
      builder: (context, state) => const AdminPaymentMethods()
    ),
  ]
);
