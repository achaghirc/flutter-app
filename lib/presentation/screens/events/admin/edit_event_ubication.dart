import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/user_info_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/repositories/event_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';

const List<String> list = <String>[ "C/","AVND","CTRA","POLIG","CIRCUNV"];

class EditEventUbication extends ConsumerStatefulWidget {
  final EventDTO event;
  const EditEventUbication({
    super.key,
    required this.event
  });

  @override
  ConsumerState<EditEventUbication> createState() => _EditEventUbicationState();
}

class _EditEventUbicationState extends ConsumerState<EditEventUbication> {
  late EventDTO _event;
  late JwtAuthenticationResponseDTO session;
  final _fbKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _event = widget.event;
    if(ref.read(sessionProvider).session != null) {
      session = ref.read(sessionProvider).session ?? JwtAuthenticationResponseDTO(status: '200', token: 'NOTOKEN', user: UserInfoDTO(id: '0', personEmail: 'personEmail', personName: 'personName', roleCode: 'roleCode', roleName: 'roleName', organizerId: List.empty(), username: 'username'));
    }else {
      context.pushReplacement('/signin');
    } 
  }
  final bool _autovalidate = false;
  late bool validSave = true;
  bool isLoading = false;
    
  Future<EventDTO?> handleSubmit() async {
    setState(() {
      isLoading = true;
    });
      EventDTO? event = await EventRepositoryImpl(session).editEvent(_event);
      isLoading = false;
      setState(() {});
      return event;  
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
                    'Especifica la ubicación',
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
              child: FormLayout(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownButtonFormField(
                            items: list.map<DropdownMenuItem<String>>((String tipoVia) {
                              return DropdownMenuItem(
                                value: tipoVia,
                                child: 
                                  Text(tipoVia),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              // do other stuff with _category
                              setState(() => _event.ubicationTypeRoad = newValue ?? list.first);
                            },
                            value: list.first,
                            decoration: InputDecoration(
                              focusColor: Theme.of(context).colorScheme.secondary,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                )
                              ),
                              border: const OutlineInputBorder(),
                              labelText: 'Tipo Vía',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.secondary
                              )
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            onChanged: (val) {
                              _event.ubicationNameRoad = val;
                            },
                            validator: (val) {
                              if(val == "") {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                            initialValue: _event.ubicationNameRoad,
                            decoration: InputDecoration(
                              focusColor: Theme.of(context).colorScheme.secondary,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                )
                              ),
                              border: const OutlineInputBorder(),
                              labelText: 'Nombre de la Vía',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.secondary
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            initialValue: _event.ubicationTown,
                            onChanged: (val) {
                              _event.ubicationTown = val;
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
                              border: const OutlineInputBorder(),
                              labelText: 'Localidad',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.secondary
                              )
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: _event.ubicationNumber,
                            onChanged: (val) {
                              _event.ubicationNumber = val;
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
                              border: const OutlineInputBorder(),
                              labelText: 'Número',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.secondary
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      initialValue: _event.ubicationProvince,
                      onChanged: (val) {
                        _event.ubicationProvince = val;
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
                        border: const OutlineInputBorder(),
                        labelText: 'Provincia',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      initialValue: _event.ubicationCountry,
                      onChanged: (val) {
                        _event.ubicationCountry = val;
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
                        border: const OutlineInputBorder(),
                        labelText: 'País',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      initialValue: _event.ubicationPostalCode,
                      onChanged: (val) {
                        _event.ubicationPostalCode = val;
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
                        border: const OutlineInputBorder(),
                        labelText: 'Código postal',
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
                            initialValue: _event.ubicationMoreInfo,
                            onChanged: (val) {
                              setState(() {
                                _event.ubicationMoreInfo = val;
                              });
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
                            handleSubmit().then((value) => {
                              if(value != null){
                                context.pushNamed("event_details", pathParameters: {'id': value.id.toString()})
                              }else {
                                CustomSnackBarWidget.openSnackBar(context,'Error', 'Error al intentar crear el evento revise los datos.')
                              }
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
                              'GUARDAR',
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