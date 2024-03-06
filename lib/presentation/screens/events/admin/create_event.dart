import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/presentation/screens/events/admin/create_event_ubication.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
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
  late bool enableLimitHour = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _initDateControlled = TextEditingController();
  final TextEditingController _endDateControlled = TextEditingController();
  final TextEditingController _limitHourController = TextEditingController();


  void buildDateFromPickers(TextEditingController controller, String paramDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030)
    );
    if (pickedDate == null) return Future.error('Error on date select');
    if (!context.mounted) return;
    TimeOfDay? selectedTime = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.fromDateTime(pickedDate)
    );
    if(selectedTime != null){
      DateTime date = DateTime(
        pickedDate.year, pickedDate.month, pickedDate.day, selectedTime.hour, selectedTime.minute
      );
      print(date);
      String formatDate =  DateFormat('dd/MM/yyyy HH:mm').format(date);
      setState(() {
        controller.text = formatDate;
        if(paramDate == 'START'){
          startDate = date;
          enableLimitHour = true;
        }else{
          endDate = date;
        }
      });
    }
  }
  void buildDateTimePicker(TextEditingController controller, DateTime paramDate) async {
    if (!context.mounted) return;
    TimeOfDay? selectedTime = await showTimePicker(
      context: context, 
      initialTime: _initDateControlled.text != '' ? TimeOfDay.fromDateTime(startDate) : TimeOfDay.fromDateTime(DateTime.now())
    );
    if(selectedTime != null){
      DateTime date = DateTime(
        DateTime.now().year, DateTime.now().month, startDate.day, selectedTime.hour, selectedTime.minute
      );
      if(date.isBefore(startDate)){
        date = date.add(const Duration(days: 1));
      }
      String formatDate =  DateFormat('HH:mm').format(date);
      setState(() {
        controller.text = formatDate;
        paramDate = date;
      });
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
            const TextIconWidget(),
            Form(
              key: _fbKey,
              autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: FormLayout(
                children: [
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
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _initDateControlled,
                      readOnly: true,
                      onTap: () => buildDateFromPickers(_initDateControlled, 'START'),
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
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _endDateControlled,
                      readOnly: true,
                      onTap: () => buildDateFromPickers(_endDateControlled, 'END'),
                      onChanged: (val) {
                        _fbKey.currentState!.validate();
                      },
                      validator: (e) {
                        if(e!= null && _initDateControlled.text != '' && endDate.isBefore(startDate)){
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
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),                  
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _limitHourController,
                      enabled: enableLimitHour,
                      onTap: () => buildDateTimePicker(_limitHourController, limitHour),
                      validator: (e) {
                        return e != null && _initDateControlled.text != '' && limitHour.millisecond < startDate.millisecond 
                            ? 'Debe ser posterior a fecha inicio'
                            : null;
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
                        labelText: 'Hora Límite',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
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
                            textInputAction: TextInputAction.done,
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
                                color: Theme.of(context).colorScheme.onBackground
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
                      width: MediaQuery.of(context).size.width * .8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
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
                                  statusCode: '',
                                  statusLocatedCode: '',
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
                                color: Colors.white,
                                fontWeight: FontWeight.w700
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