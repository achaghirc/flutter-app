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
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/navigation/app_bar_actions.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';

const List<String> list = <String>[ "C/","AVND","CTRA","POLIG","CIRCUNV"];

class CreateEventUbication extends ConsumerStatefulWidget {
  final EventDTO prevEventData;
  const CreateEventUbication({
    super.key,
    required this.prevEventData
  });

  @override
  ConsumerState<CreateEventUbication> createState() => _CreateEventUbicationState();
}

class _CreateEventUbicationState extends ConsumerState<CreateEventUbication> {
  late EventDTO prevEventDTO;
  late JwtAuthenticationResponseDTO session;
  final _fbKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prevEventDTO = widget.prevEventData;
    if(ref.read(sessionProvider).session != null) {
      session = ref.read(sessionProvider).session ?? JwtAuthenticationResponseDTO(status: '200', token: 'NOTOKEN', user: UserInfoDTO(id: '0', personEmail: 'personEmail', personName: 'personName', roleCode: 'roleCode', roleName: 'roleName', organizerId: List.empty(), username: 'username'));
    }else {
      context.pushReplacement('/signin');
    } 
  }
  late String typeRoad = '';
  late String nameRoad;
  late String number;
  late String town;
  late String province;
  late String country;
  late String postalCode;
  late String moreInfo;
  final bool _autovalidate = false;
  late bool validSave = true;
  bool isLoading = false;
  
  final TextEditingController _nameRoadController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();
  
  Future<EventDTO?> handleSubmit() async {
    setState(() {
      isLoading = true;
    });
      prevEventDTO.ubicationTypeRoad = typeRoad;
      prevEventDTO.ubicationNameRoad = nameRoad;
      prevEventDTO.ubicationNumber = number;
      prevEventDTO.ubicationTown = town;
      prevEventDTO.ubicationProvince = province;
      prevEventDTO.ubicationCountry = country;
      prevEventDTO.ubicationPostalCode = postalCode;
      prevEventDTO.ubicationMoreInfo = moreInfo;
      prevEventDTO.organizerId = int.parse(session.user.organizerId.first);
      EventDTO? event = await EventRepositoryImpl(session).create(prevEventDTO);
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
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          children: <Widget>[
            const TextIconWidget(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Especifica la ubicación',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700
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
                    padding: const EdgeInsets.all(8.0),
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
                              setState(() => typeRoad = newValue ?? list.first);
                            },
                            value: list.first,
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
                              labelText: 'Tipo Vía',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.onBackground
                              )
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _nameRoadController,
                            onChanged: (val) {
                              nameRoad = val;
                              _nameRoadController.text = val;
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'Nombre de la Vía',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.onBackground
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _townController,
                            onChanged: (val) {
                              town = val;
                              _townController.text = val;
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'Localidad',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.onBackground
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
                            controller: _numberController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              number = val;
                              _numberController.text = val;
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'Número',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.onBackground
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _provinceController,
                      onChanged: (val) {
                        province = val;
                        _provinceController.text = val;
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Provincia',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _countryController,
                      onChanged: (val) {
                        country = val;
                        _countryController.text = val;
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'País',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _postalCodeController,
                      onChanged: (val) {
                        postalCode = val;
                        _postalCodeController.text = val;
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Código postal',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                   Container(
                    padding: const EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _moreInfoController,
                            onChanged: (val) {
                              setState(() {
                                moreInfo = val;
                              });
                              _moreInfoController.text = val;
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
                    height: MediaQuery.of(context).size.height * 0.07,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: (){
                           if(_fbKey.currentState!.validate()){
                            handleSubmit().then((value) => {
                              if(value != null){
                                context.go('/home')
                              }else {
                                setState(() => isLoading = false),
                                CustomSnackBarWidget.openSnackBar(context, 'Error', 'Error al intentar crear el evento revise los datos.')
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
                              'CREAR',
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