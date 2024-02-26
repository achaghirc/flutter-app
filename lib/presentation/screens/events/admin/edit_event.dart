import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/repositories/event_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/screens/events/admin/edit_event_ubication.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';


class EditEvent extends ConsumerStatefulWidget {
  final EventDTO event;
  const EditEvent({
    super.key,
    required this.event
    });

  @override
  ConsumerState<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends ConsumerState<EditEvent> {
  late JwtAuthenticationResponseDTO? session;
  late EventDTO _event;
  final _fbKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late DateTime startDate;
  late DateTime endDate;
  late DateTime limitHour;
  final formatHour = DateFormat("HH:mm");
  final formatDate = DateFormat("dd/MM/yyyy HH:mm");
  final bool _autovalidate = false;
  var isLoading = false;
  
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    if(ref.exists(sessionProvider) && ref.read(sessionProvider).session == null){
      context.pushReplacementNamed('signin');
    }else {
      session = ref.read(sessionProvider).session;
    }
    _event = widget.event;
    startDate = DateTime.tryParse(_event.startDate) ?? DateTime.now();
    endDate = DateTime.tryParse(_event.endDate) ?? DateTime.now();
    limitHour = DateTime.tryParse(_event.limitHour) ?? DateTime.now();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _nameController.value = TextEditingValue(text: _event.name);
    _descriptionController.value = TextEditingValue(text: _event.description);
  }

  Future<EventDTO> editAndSaveEvent() async{
    
    try{
      setState(() {
        isLoading = true;
      });
      EventDTO? eventDTO = await EventRepositoryImpl(session).editEvent(_event);
      if(eventDTO != null){
        return eventDTO;
      } else{
        throw Error(); 
      }
    }on Error {
      throw ErrorDescription("Error updating event");
    }

    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          AppBarActions()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextIconWidget(size: 55),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.03, 0),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 30.0,
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditEventUbication(event: _event);
                              }
                            )
                          );
                        },
                        icon: const Icon(Icons.edit_location_alt_outlined),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Edita tu evento',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
             Form(
              key: _fbKey,
              autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: FormLayout(children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _nameController,
                      onChanged: (val) {
                        _nameController.text = val;
                        _event.name = val;
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
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        suffixIcon: const Icon(Icons.edit_note_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Nombre',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: DateTimeFormField(
                      use24hFormat: true,
                      onDateSelected: (DateTime val) {
                        _event.startDate = "${Moment(val).format("YYYY-MM-DDTHH:mm:ss")}Z";
                      },
                      initialValue: startDate,
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        hintStyle: const TextStyle(color: Colors.black45),
                        errorStyle:const TextStyle(color: Colors.redAccent),
                        suffixIcon:const Icon(Icons.event_note_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Fecha de Inicio',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: DateTimeFormField(
                      use24hFormat: true,
                      onDateSelected: (val) {
                        _event.endDate = "${Moment(val).format("YYYY-MM-DDTHH:mm:ss")}Z";
                      },
                      initialValue: endDate,
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) {
                        if(e!= null && e.isBefore(startDate)){
                          return 'Fecha fin debe ser posterior a fecha inicio.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        hintStyle: const TextStyle(color: Colors.black45),
                        errorStyle:const TextStyle(color: Colors.redAccent),
                        suffixIcon:const Icon(Icons.event_note_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Fecha de Fin',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: DateTimeFormField(
                      use24hFormat: true,
                      onDateSelected: (val) {
                        _event.limitHour = "${Moment(val).format("YYYY-MM-DDTHH:mm:ss")}Z";
                      },
                      autovalidateMode: AutovalidateMode.always,
                      validator: (DateTime? e) {
                        return (e?.millisecond ?? 0) < startDate.millisecond
                            ? 'Debe ser posterior a fecha inicio'
                            : null;
                      },
                      initialValue: limitHour,
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        hintStyle: const TextStyle(color: Colors.black45),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: const Icon(Icons.schedule_outlined),
                        labelText: 'Hora límite',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _descriptionController,
                            onChanged: (val) {
                              setState(() {
                                _event.description = val;
                              });
                              _descriptionController.text = val;
                            },
                            validator: (val) {
                              if(val == "") {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: null,
                            maxLength: 80,
                            //expands: true,
                            decoration: InputDecoration(
                              focusColor: Theme.of(context).colorScheme.secondary,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                )
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'Descripción',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.secondary
                              ),
                              
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        onPressed: (){
                           if(_fbKey.currentState!.validate()){
                            editAndSaveEvent().then((value) => {
                              context.pop()
                            }).catchError((e){
                              throw ErrorDescription(e.toString());
                            });
                          }
                        },
                        child: (
                          isLoading ? 
                            const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            :
                            Text(
                              'EDITAR',
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.background,
                              ),
                          )
                        ),
                      ),
                    ),
                  ),
                ]
              )
            )
          ]
        )
      ),
    );
  }
}