import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/image/imageDTO.dart';
import 'package:my_app/infraestructure/models/squad/event_public_relations_dto.dart';
import 'package:my_app/infraestructure/repositories/event_public_relations_repository_impl.dart';
import 'package:my_app/presentation/screens/events/admin/events_screen_details.dart';
import 'package:my_app/presentation/screens/events/events_screen.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/search/search_widget.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpp.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_rrpps_list.dart';

class CardEvent extends StatelessWidget {

  final int id;
  final String titleCard;
  final String? subtitle;
  final String? startDate;
  final String? location;
  final String status;
  final List<ImageDTO> images;
  final double? heightFactor;
  final bool limitSubtitle;
  final JwtAuthenticationResponseDTO? session;
  final String? rrppCode;

  const CardEvent({
    super.key,
    required this.id,
    required this.titleCard,
    this.subtitle,
    this.startDate,
    this.location,
    required this.status,
    required this.images,
    this.heightFactor,
    this.limitSubtitle = true,
    this.session,
    this.rrppCode
  });

  @override
  Widget build(BuildContext context) {

    ImageProvider buildImage() {
      if (images.isEmpty || images.first.title == 'Default') { 
        return const AssetImage('assets/santaliaimage.jpg');
      }else{ 
        return MemoryImage(images.first.data);
      }
    }

    Widget buildStatusIcon(){
      late Widget icon = Icon(Icons.pause_circle_outline_outlined);
      switch(status){
        case 'ACTIVE': 
          icon = const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          );
          break;
        case 'SCHEDULED':
          icon = const Icon(
            Icons.access_time_outlined,
            color: Colors.grey,
          );
          break;
        case 'FINISHED':
          icon = const Icon(
            Icons.circle_rounded,
            color: Colors.red, 
          );
          break;
      }
      return icon;
    }


    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * (heightFactor ?? 0.25),
      child: Center(
        child: Card(
          elevation: 4,
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0)
            )
          ),
          child: InkWell(
            onTap: () {
              if((session!.user.roleCode == 'USER') || (session!.user.roleCode == 'RRPP' && rrppCode == null)){
                BottomSheetWidget.showModalBottomSheet(
                  context, 
                  _EventSelectRelationPublic(eventId: id, session: session!,), 
                  MediaQuery.of(context).size.height * 0.9, 
                  MediaQuery.of(context).size.height * 0.8,
                  null,
                  null,
                );
              }else {
                context.pushNamed("event_details", pathParameters: {'id': id.toString(), 'publicRelationCode': rrppCode ?? 'ADMIN', "assigned": "Y"});
              }
            },
            child: Stack(
              children: [
                 Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: buildImage()
                    )
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: buildStatusIcon()
                ),
                FadeIn(
                  duration: const Duration(seconds: 1),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            titleCard, 
                            style: const TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                              )
                            ),
                          subtitle: Text(
                            limitSubtitle ? "${subtitle!.substring(0, subtitle!.length > 50 ? 50 : subtitle!.length)}..." : subtitle ?? '',
                             style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w300
                             ),
                          ),
                        ),
                        if(startDate != null)
                          CardInformation(information: Moment.parse(startDate ?? '', localization: MomentLocalizations.es()).LL, icon: Icons.calendar_month_outlined),
                        if(startDate != null)
                          CardInformation(information: Moment.parse(startDate ?? '', localization: MomentLocalizations.es()).LT, icon: Icons.access_time),
                        if(location != null)
                          CardInformation(information: location ?? '', icon: Icons.location_on_outlined)
                      ],
                    ),
                  ),
                ),
              ] 
            ),
          ),
        ),
      ),
    );
  }
}

class CardInformation extends StatelessWidget {

  final String information;
  final IconData icon;

  const CardInformation({
    super.key,
    required this.information,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0,0,0,0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              information,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _EventSelectRelationPublic extends StatefulWidget {
  final int eventId;
  final JwtAuthenticationResponseDTO session;
  const _EventSelectRelationPublic({
    super.key,
    required this.eventId,
    required this.session
  });

  @override
  State<_EventSelectRelationPublic> createState() => _EventSelectRelationPublicState();
}

class _EventSelectRelationPublicState extends State<_EventSelectRelationPublic> {
  late int _eventId;
  late Future<List<EventPublicRelationsDTO>> futureRelationPublicList;
  late List<EventPublicRelationsDTO> publicRelationsList = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController _ticketCodeController = TextEditingController();
  late FocusNode _searchFocusNode;
  late bool selected = false;
  late List<EventPublicRelationsDTO> selectedRelationPublic = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(_searchFocus);
    _eventId = widget.eventId;
    futureRelationPublicList = searchActivePublicRelationsForEvent();
  }
  void _searchFocus(){}

 Future<List<EventPublicRelationsDTO>> searchActivePublicRelationsForEvent() async{
    if(publicRelationsList.isNotEmpty && _ticketCodeController.text.length == 8){
      publicRelationsList = publicRelationsList.where((publicRelation) => publicRelation.rrppCode == _ticketCodeController.text).toList();
    }else if(publicRelationsList.isEmpty && searchController.text == ''){
       List<EventPublicRelationsDTO> publicRelationsDBList = 
      await EventPublicRelationsRepositoryImpl(widget.session).getAllPublicRelationdByEventId(_eventId.toString());
      publicRelationsList = publicRelationsDBList;
    }
    return publicRelationsList;
  }
  Future<void> _refreshPublicRelationsList() async {
    List<EventPublicRelationsDTO> publicRelationsDBList = await EventPublicRelationsRepositoryImpl(widget.session).getAllPublicRelationdByEventId(_eventId.toString());
    setState(() {
      publicRelationsList = publicRelationsDBList;
    });  
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchFocusNode.removeListener(_searchFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom == 0 ? 
          MediaQuery.of(context).size.height * 0.03 
          :
          MediaQuery.of(context).size.height * 0.07,
        ),
        Text(
          'Selecciona tu RRPP',
          style: GoogleFonts.nunito(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.10,
          padding: const EdgeInsets.fromLTRB(20,15,20,15),
          child: TextFormField(
            controller: _ticketCodeController,
            onChanged: (val) {
              if(val.length == 8){
                setState(() {});
              }
            },
            validator: (val) {
              if(val == "") {
                return 'Campo obligatorio';
              }
              return null;
            },
            decoration: InputDecoration(
              focusColor: Theme.of(context).colorScheme.secondary,
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                )
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              suffixIcon: FadeIn(
                duration: const Duration(milliseconds: 200),
                animate: _ticketCodeController.text != "",
                child: IconButton(
                  icon: Icon(
                      Icons.close_outlined,
                    color: Theme.of(context).colorScheme.secondary,  
                  ),
                  onPressed: () {
                    _ticketCodeController.text = "";
                    setState(() {});
                  },
                ),
              ),
              labelText: 'Código',
              labelStyle: GoogleFonts.nunito(
                color: Theme.of(context).colorScheme.secondary
              )
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          child: Text(
            'En caso de no disponer de código de RRPP, selecciona uno de los siguientes o busca tu RRPP de confianza.',
            maxLines: 2,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
          child: SearchWidget(
            searchController: searchController,
            focusNode: _searchFocusNode,
            placeholder: 'Buscar', 
            onChanged: (val){
              if(val.isNotEmpty && val.length > 2){
                setState(() {});
              }
            },
            onClear: (){
              setState(() {});
            }, 
            onTap: (){},
            outlineInputDecoration: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                color: Theme.of(context).colorScheme.secondary
              ),
              borderRadius: BorderRadius.circular(20.0)
            ),
            focusBorder: OutlineInputBorder(
              borderSide: const BorderSide(style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(20.0)
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0,15.0,0.0,0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Resultados',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.black12,
          endIndent: 20.0,
          indent: 20.0,
          height: 5,
        ),
        Expanded(
          child: FutureBuilder(
            future: futureRelationPublicList,
            initialData: publicRelationsList,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                return ShimmedRRPPSList(size: publicRelationsList.isEmpty ? 9 :  publicRelationsList.length );
              } else {
                String emptyMessage = 'Este evento no tiene asignados relaciones publicas.';
                List<EventPublicRelationsDTO> data = snapshot.data as List<EventPublicRelationsDTO>;
                if(searchController.text.isEmpty && _ticketCodeController.text.length == 8){
                  data = publicRelationsList;
                  emptyMessage = 'El código, no coincide con ningún relaciones públicas asignado.';
                }
                if(searchController.text.length > 2){
                  data = data.where((element) => element.userUsername.contains(searchController.text)).toList();
                }
                if(data.isEmpty && searchController.text == ''){
                  return Center(
                    child: Text(
                      emptyMessage,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      ),
                    ),
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
                              return ListTile(
                                onTap: () {
                                  context.pushNamed("event_details", pathParameters: {'id': _eventId.toString(), 'publicRelationCode': publicRelation.rrppCode, 'assigned': 'N'});
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return EventsScreenDetails(id: _eventId.toString(), publicRelationCode: publicRelation.rrppCode);
                                        }));
                                        //context.pushReplacementNamed("event_details", pathParameters: {'id': _eventId.toString(), 'publicRelationId': publicRelation.id.toString()});
                                      },
                                      icon: const Icon(Icons.arrow_forward),
                                      color: Theme.of(context).iconTheme.color,
                                    )
                                  ],
                                ),
                              );
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
    );
  }
}