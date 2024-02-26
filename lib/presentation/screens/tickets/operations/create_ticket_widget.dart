import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/models/tickets/type/tickets_type_dto.dart';
import 'package:my_app/infraestructure/repositories/event_tickets_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/search_tickets_type_params.dart';
import 'package:my_app/infraestructure/repositories/tickets_type_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';

const List<String> list2 = <String>[ "Entrada simple","Entrada + Consumición","Entrada + Bonocopa","Bonocopa 2x10","Bonocopa 3x15"];

class FormCreateTicket extends ConsumerStatefulWidget {
  final int eventId;
  final String eventDate;
  const FormCreateTicket({
    super.key,
    required this.eventId,
    required this.eventDate
  });

  @override
  ConsumerState<FormCreateTicket> createState() => _FormCreateTicketState();
}

class _FormCreateTicketState extends ConsumerState<FormCreateTicket> {
  late int _eventId;
  late String _eventDate;
  late JwtAuthenticationResponseDTO session;
  late List<TicketsTypeDTO> ticketsTypes = [];
  final _fbKey = GlobalKey<FormState>();
  final bool _autovalidate = false;
  late bool isLoading = false;
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _ticketPriceController = TextEditingController();
  final TextEditingController _ticketCommissionController = TextEditingController();
  final TextEditingController _ticketAmountController = TextEditingController();
  late String ticketType = '';
  late bool available = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!ref.exists(sessionProvider)){
      context.pushReplacementNamed('signin');
    }
    _eventId = widget.eventId;
    _eventDate = widget.eventDate;
    session = ref.read(sessionProvider).session!;
    findTicketTypesListByOrganizer().then((value) => {
      setState(() {
        ticketsTypes = value;
      })
    });
  }

  Future<List<TicketsTypeDTO>> findTicketTypesListByOrganizer() async{
    TicketsTypeQueryParams typeQueryParams = TicketsTypeQueryParams(organizerId: int.parse(session.user.organizerId.first));
    List<TicketsTypeDTO> result = await TicketsTypeRepositoryImpl(session).search(typeQueryParams);
    return result;
  }

  Future<void> createTicket() async{
    setState(() {
      isLoading = true;
    });
    try{
      int ticketTypeId = ticketsTypes.where((element) => element.encoderName == ticketType).first.id!;
      EventTicketsDTO tickets = EventTicketsDTO(name: _ticketNameController.text, 
      price: double.parse(_ticketPriceController.text), 
      amount: int.parse(_ticketAmountController.text), 
      currentAmount: int.parse(_ticketAmountController.text), 
      available: available, 
      eventId: _eventId, 
      eventDate: _eventDate, 
      ticketsTypeId: ticketTypeId,
      ticketCommission: double.parse(_ticketCommissionController.text)
      );
      await EventTicketsRepositoryImpl(session).create(tickets);
    }catch(err) {
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
                    'Crea tus entradas',
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
                      },
                      validator: (val) {
                        if(val == "") {
                          return 'Campo obligatorio';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.onBackground,
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
                    padding: const EdgeInsets.fromLTRB(20,0,20,15),
                    child: DropdownButtonFormField(
                      items: ticketsTypes.isEmpty ? 
                        const [] 
                        : 
                        ticketsTypes.map<DropdownMenuItem<String>>((TicketsTypeDTO ticketType) {
                          return DropdownMenuItem(
                            value: ticketType.encoderName.toString(),
                            key: Key(ticketType.id.toString()),
                            child: 
                              Text(ticketType.encoderName),
                            );
                        }).toList(),
                      icon: ticketsTypes.isEmpty ? 
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                          child: const CircularProgressIndicator(),
                        ) 
                        : 
                        null,
                      onChanged: (newValue) {
                        ticketType = newValue.toString();
                        _ticketNameController.text = ticketType;
                      },
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.onBackground,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        labelText: 'Tipo de Entrada',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      )
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,15.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _ticketPriceController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                            },
                            validator: (val) {
                              if(val == "") {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusColor: Theme.of(context).colorScheme.onBackground,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                )
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              labelText: 'Precio',
                              labelStyle: GoogleFonts.nunito(
                                color: Theme.of(context).colorScheme.onBackground
                              )
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            controller: _ticketCommissionController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                            },
                            validator: (val) {
                              if(val == "") {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusColor: Theme.of(context).colorScheme.onBackground,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                )
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              labelText: 'Comisión',
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
                    padding: const EdgeInsets.fromLTRB(20,15,20,0),
                    child: TextFormField(
                      controller: _ticketAmountController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                      },
                      validator: (val) {
                        if(val == "") {
                          return 'Campo obligatorio';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusColor: Theme.of(context).colorScheme.onBackground,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        labelText: 'Cantidad',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35,0,0,0),
                        child: Text(
                          'Disponible',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,30,0),
                        child: Switch(
                          value: available,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.black12,
                          thumbIcon: MaterialStateProperty.resolveWith((states) => available ? const Icon(Icons.check_outlined, color: Colors.white) : null),
                          activeColor: Colors.greenAccent,
                          activeTrackColor: Colors.black12,
                          onChanged: (bool value) {
                            setState(() {
                              available = !available;
                            });
                          },
                        ),
                      ),
                    ],
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
                        createTicket().then((value) {
                          CustomSnackBarWidget.openSnackBar(context, 'Success', 'Entradas creadas correctamente');
                          context.pop();
                        }).catchError((onError) {
                          CustomSnackBarWidget.openSnackBar(context, 'Error', 'Error creando entradas, intentelo de nuevo.');
                          context.pop();
                        });
                      }, 
                      child: isLoading ? 
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
