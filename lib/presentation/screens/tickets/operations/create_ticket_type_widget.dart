import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/tickets/type/tickets_type_dto.dart';
import 'package:my_app/infraestructure/repositories/tickets_type_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';

class FormCreateTicketType extends ConsumerStatefulWidget {
  const FormCreateTicketType({super.key});

  @override
  ConsumerState<FormCreateTicketType> createState() => _FormCreateTicketTypeState();
}

class _FormCreateTicketTypeState extends ConsumerState<FormCreateTicketType> {
  late JwtAuthenticationResponseDTO session;
  final _fbKey = GlobalKey<FormState>();
  final bool _autovalidate = false;
  late String name;
  late String description= '';
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _ticketDescriptionController = TextEditingController();
  late bool available = false;
  late bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!ref.exists(sessionProvider)){
      context.pushReplacementNamed('signin');
    }
    session = ref.read(sessionProvider).session!;
  }

  TicketsTypeDTO buildTicketType() {
    TicketsTypeDTO ticketsTypeDTO = TicketsTypeDTO(
      encoderName: name, 
      encoderCode: name.replaceAll(" ", "_").replaceAll("+", "Y").toUpperCase(), 
      encoderLocatedCode: name, 
      encoderDescription: description, 
      organizerId: int.parse(session.user.organizerId.first), 
    );
    return ticketsTypeDTO;
  }

  Future<void> createTicketType() async {
    try{
      setState(() {
        isLoading = true;
      });
      TicketsTypeDTO ticketsType = buildTicketType();
      await TicketsTypeRepositoryImpl(session).create(ticketsType);
    }catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            const TextIconWidget(size: 45),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Crea tipos de entradas',
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
            Form(
              key: _fbKey,
              autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: FormLayout(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20,15,20,15),
                    child: TextFormField(
                      controller: _ticketNameController,
                      onChanged: (val) {
                        name = val;
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
                        labelText: 'Nombre',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20,0,20,0),
                    child: TextFormField(
                      controller: _ticketDescriptionController,
                      onChanged: (val) {
                        setState(() {
                          description = val;
                        });
                      },
                      maxLength: 80,
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
                        labelText: 'Description',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.08,
                    padding: const EdgeInsets.fromLTRB(0,15,0,0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.secondary),
                      ),
                      onPressed: (){
                        createTicketType().then(
                          (value) {
                            CustomSnackBarWidget.openSnackBar(context, 'Sucess', 'Tipo de entrada creado correctamente');
                            context.pop();
                          }
                        ).catchError((onError) {
                          CustomSnackBarWidget.openSnackBar(context, 'Error', 'Error creando tipo de entrada, intentelo de nuevo.');
                          context.pop();
                        });
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
                            fontWeight: FontWeight.w400
                          ),
                        )
                      )
                    ),
                  )
                ]
              )
            )
          ]
        )
    );
        
  }
}