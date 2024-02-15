import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/presentation/screens/events/admin/create_event_ubication.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _fbKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  late DateTime limitHour = DateTime.now();
  final formatHour = DateFormat("HH:mm");
  final formatDate = DateFormat("dd/MM/yyyy HH:mm");
  final bool _autovalidate = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Outnow',
                  style: GoogleFonts.nunito(
                    fontSize: 55,
                    fontWeight: FontWeight.w800
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Crea tu evento',
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
                        name = val;
                        _nameController.text = val;
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
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        suffixIcon: const Icon(Icons.edit_note_outlined),
                        border: const OutlineInputBorder(),
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
                        startDate = val;
                      },
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        hintStyle: const TextStyle(color: Colors.black45),
                        errorStyle:const TextStyle(color: Colors.redAccent),
                        suffixIcon:const Icon(Icons.event_note_outlined),
                        border: const OutlineInputBorder(),
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
                        endDate = val;
                      },
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
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        hintStyle: const TextStyle(color: Colors.black45),
                        errorStyle:const TextStyle(color: Colors.redAccent),
                        suffixIcon:const Icon(Icons.event_note_outlined),
                        border: const OutlineInputBorder(),
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
                        limitHour = val;
                      },
                      autovalidateMode: AutovalidateMode.always,
                      validator: (DateTime? e) {
                        return (e?.millisecond ?? 0) < startDate.millisecond
                            ? 'Debe ser posterior a fecha inicio'
                            : null;
                      },
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.secondary,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        hintStyle: const TextStyle(color: Colors.black45),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                        border: const OutlineInputBorder(),
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
                                description = val;
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
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                )
                              ),
                              border: const OutlineInputBorder(),
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
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CreateEventUbication(prevEventData: EventDTO(id: 0, 
                                  name: name, 
                                  description: description, 
                                  startDate: "${Moment(startDate).format("YYYY-MM-DDTHH:mm:ss")}Z", 
                                  endDate: "${Moment(endDate).format("YYYY-MM-DDTHH:mm:ss")}Z", 
                                  limitHour: "${Moment(limitHour).format("YYYY-MM-DDTHH:mm:ss")}Z",
                                  organizerId: 0, 
                                  organizerName: '', 
                                  ubicationTypeRoad: '', 
                                  ubicationNameRoad: '', 
                                  ubicationNumber: '', 
                                  ubicationTown: '', 
                                  medias: []));
                                }
                              )
                            );
                          }
                        },
                        child: (
                          Text(
                              'CONTINUAR',
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