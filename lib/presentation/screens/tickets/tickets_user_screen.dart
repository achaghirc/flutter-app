import 'package:flutter/material.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/tickets/custom/tickets_grouped_dto.dart';
import 'package:my_app/infraestructure/models/tickets/tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/tickets_query_params.dart';
import 'package:my_app/infraestructure/repositories/tickets_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/widgets/cards/tickets/ticket_card_widget.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/navigation/bottom_navigation_widget.dart';

class TicketsUserScreen extends ConsumerStatefulWidget {
  const TicketsUserScreen({super.key});

  @override
  ConsumerState<TicketsUserScreen> createState() => _TicketsUserScreenState();
}

class _TicketsUserScreenState extends ConsumerState<TicketsUserScreen> {
  late JwtAuthenticationResponseDTO session;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late List<TicketsDTO> tickets = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session = ref.read(sessionProvider).session!;
  }
  
  Future<List<TicketsGroupedDTO> > search() async {
      TicketsQueryParams searchParams = TicketsQueryParams(userId: int.parse(session.user.id));
      List<TicketsGroupedDTO> result = await TicketsRepositoryImpl(session).searchGrouped(searchParams);
      return result;    
  }

  Future<List<TicketsGroupedDTO>> refreshPublicRelationsList() async {
    TicketsQueryParams searchParams = TicketsQueryParams(userId: int.parse(session.user.id));
    List<TicketsGroupedDTO> tickets = await TicketsRepositoryImpl(session).searchGrouped(searchParams);
    return tickets; 
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              onPressed: (){
                context.pop();
              }, 
              icon: const Icon(Icons.arrow_back)
            );
          }
        ),
        title: Text(
          'Entradas',
          style: GoogleFonts.nunito(),
        ),
        actions: const [
          AppBarActions()
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
          child: FutureBuilder(
            future: search(),
            initialData: tickets,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                String emptyMessage = 'No tienes ninguna entrada comprada aún.';
                List<TicketsGroupedDTO> data = snapshot.data as List<TicketsGroupedDTO>;
                if(data.isEmpty){
                  return Center(
                    child: Text(
                      emptyMessage,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  );
                }
                return GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children:List.generate(data.length, (index) {
                      TicketsGroupedDTO ticket = data.elementAt(index);
                      return TicketCardEvent(ticketsGrouped: ticket);
                  })
                );
              }
            },
          ),
        ),
        ]
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}

class _TicketUserDetailsWidget extends StatelessWidget {
  final TicketsDTO ticket;
  const _TicketUserDetailsWidget({
    super.key,
    required this.ticket
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20.0, 0,0),
          child: Text(
            ticket.eventTicketEventName!,
            style: GoogleFonts.nunito(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  fit: BoxFit.cover,
                  image: MemoryImage(ticket.qrCode!),
                ),
              
            ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          '${ticket.ticketsTypeEncoderName!} ${globals.buildTicketPrice(ticket.price)}€',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${ticket.ticketCode}',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
          
      ],
    );
  }
}