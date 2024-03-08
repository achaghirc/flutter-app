import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/custom/open_event_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/repositories/event_open_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/screens/authentication/signup_screen.dart';
import 'package:my_app/presentation/screens/screens.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/cards/card_event.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/event/information_widget.dart';

class OpenEventDetailsScreen extends ConsumerStatefulWidget {
  final String? id;
  final String? publicRelationCode;
  const OpenEventDetailsScreen({
    super.key,
    this.id,
    this.publicRelationCode
  });

  @override
  ConsumerState<OpenEventDetailsScreen> createState() => _OpenEventDetailsScreenState();
}

class _OpenEventDetailsScreenState extends ConsumerState<OpenEventDetailsScreen> {
  late JwtAuthenticationResponseDTO session;
  late bool alreadyLogged = false;

  Future<OpenEventDTO?> getEvent() async {
    OpenEventDTO? event = await EventOpenRepositoryImpl(null).findEventById(widget.id!);
    return event;   
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(ref.read(sessionProvider).session == null){
      alreadyLogged = false;
    }else{
      alreadyLogged = true;
      session = ref.read(sessionProvider).session!;
      context.pushReplacementNamed('event_details');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: FutureBuilder(
      future: getEvent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!snapshot.hasData) {
          return const Center(
            child: Text(
              'No coincide con ningún evento'
            ),
          );
        }else {
          OpenEventDTO openEvent = snapshot.data as OpenEventDTO;
          EventDTO event = openEvent.event;
          List<EventTicketsDTO> tickets = openEvent.tickets;
          return  ListView(
              children: [
                CardEvent(
                  id: event.id, 
                  titleCard: event.name, 
                  subtitle: event.description, 
                  startDate: event.startDate,
                  images: event.medias,
                  status: event.statusCode,
                  heightFactor: 0.18,
                  limitSubtitle: false,
                ),
                const SizedBox(
                  height: 20
                ), 
                //Center(child: RowChipsWidget(publicRelationCode: widget.publicRelationCode)),
                const SizedBox(
                  height: 20
                ),
                //EVENT INFORMATION WIDGET
                InformationEventWidget(event: event),
                //EVENT MANAGENMENT ONLY ROLE ADMIN             
                _EventTicketsShoppingWidget(tickets: tickets, event: event, publicRelationCode: widget.publicRelationCode!)
              ],
            );
        }
      }
    ),
    );
  }
}

class _ManageLoginOpenEvent extends StatelessWidget {
  final EventDTO event;
  final String publicRelationCode;
  const _ManageLoginOpenEvent({
    super.key,
    required this.event,
    required this.publicRelationCode
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const TextIconWidget(size: 45),
          trailing: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close_outlined),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Para poder continuar con la compra debes iniciar sesión en el sistema o registrarte. Te tomará poco tiempo. Te espamos !!',
            style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
        const Divider(
          indent: 10,
          endIndent: 10,
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.025,
        ),
        Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.background
              ),
              onPressed: (){
                BottomSheetWidget.showModalBottomSheet(
                  context,
                  SignupScreen(showFooter: false, pathTo: '/event/${event.id}/$publicRelationCode/N',),
                  MediaQuery.of(context).size.height * 0.8,
                  MediaQuery.of(context).size.height * 0.8,
                  MediaQuery.of(context).size.width,
                  null,
                );
              },
              label: Text(
                'Registrarte',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Theme.of(context).colorScheme.secondary,
              )
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.025,
        ),
        Container(
          height: 50,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary
              ),
              onPressed: (){
                BottomSheetWidget.showModalBottomSheet(
                  context,
                  SignInScreen(showFooter: false, pathTo: '/event/${event.id}/$publicRelationCode/N',),
                  MediaQuery.of(context).size.height * 0.8,
                  MediaQuery.of(context).size.height * 0.8,
                  MediaQuery.of(context).size.width,
                  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color: Theme.of(context).colorScheme.surface
                  ),
                );
              },
              label: Text(
                'Iniciar Sesión',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Theme.of(context).colorScheme.onBackground,
              )
            ),
          ),
        ),
      ],
    );
  }
}

class _EventTicketsShoppingWidget extends StatelessWidget {
  final EventDTO event;
  final String publicRelationCode;
  final List<EventTicketsDTO> tickets;
  const _EventTicketsShoppingWidget({
    super.key,
    required this.tickets,
    required this.event,
    required this.publicRelationCode
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            'Entradas',
            style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const Divider(
          endIndent: 10.0,
          indent: 10.0,
          height: 2,
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tickets.length,
          separatorBuilder: (context, index) => 
            const Divider(
              color: Colors.black12,
              endIndent: 20.0,
              indent: 20.0,
              height: 5,
            ),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            EventTicketsDTO ticket = tickets.elementAt(index);
            return ListTile(
              onTap: () {
                BottomSheetWidget.showModalBottomSheet(
                  context,
                  _ManageLoginOpenEvent(event: event, publicRelationCode: publicRelationCode,),
                  MediaQuery.of(context).size.height * 0.6,
                  MediaQuery.of(context).size.height * 0.6,
                  MediaQuery.of(context).size.width,
                  null,
                );
              },
              title: Text(
                ticket.name,
                style: GoogleFonts.nunito(
                      
                ),
              ),
              subtitle: Text(
                ticket.ticketsTypeEncoderName!,
                style: GoogleFonts.nunito(
                  
                ),
              ),
              leading: const Icon(
                Icons.local_activity_outlined
              ),
              trailing: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Text(
                      '${ticket.price}€',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        )
      ],
    );
  }
}


class _SignIn extends StatelessWidget {
  const _SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(

    );
  }
}