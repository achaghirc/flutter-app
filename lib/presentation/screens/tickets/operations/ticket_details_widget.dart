import 'package:flutter/material.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_details_dart.dart';
import 'package:my_app/infraestructure/models/tickets/event_tickets_dto.dart';
import 'package:my_app/infraestructure/models/tickets/type/tickets_type_dto.dart';
import 'package:my_app/infraestructure/repositories/event_tickets_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/search_tickets_type_params.dart';
import 'package:my_app/infraestructure/repositories/tickets_type_repository_impl.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_data_resume_widget.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';
import 'package:my_app/shared/widgets/tickets/data_resume_widget.dart';

const double inputPaddingLeft = 20.0;
const double inputPaddingTop = 0.0;
const double inputPaddingRigth = 20.0;
const double inputPadingBottom = 15.0;


class TicketDetailsWidget extends StatefulWidget {
  final EventTicketsDTO ticket;
  final EventDTO event;
  final JwtAuthenticationResponseDTO session;

  const TicketDetailsWidget({
    super.key,
    required this.ticket,
    required this.event,
    required this.session
  });

  @override
  State<TicketDetailsWidget> createState() => _TicketDetailsWidgetState();
}

class _TicketDetailsWidgetState extends State<TicketDetailsWidget> {
  late EventTicketsDTO _ticket;
  late JwtAuthenticationResponseDTO session;
  late EventTicketsDetailsDTO detailsData;
  late List<TicketsTypeDTO> ticketsTypes = [];
  final _fbKey = GlobalKey<FormState>();
  final bool _autovalidate = false;
  late bool isLoading = false;
  late String _ticketName;
  late double _ticketPrice;
  late int _ticketAmount;
  late double _ticketCommission;
  late String _ticketType;
  late bool _available;
  late bool isEditable = false;

  Future<List<TicketsTypeDTO>> findTicketTypesListByOrganizer() async{
    TicketsTypeQueryParams typeQueryParams = TicketsTypeQueryParams(organizerId: int.parse(session.user.organizerId.first));
    List<TicketsTypeDTO> result = await TicketsTypeRepositoryImpl(session).search(typeQueryParams);
    return result;
  }

  Future<EventTicketsDetailsDTO> findTicketDetailsData() async {
    EventTicketsDetailsDTO data = await EventTicketsRepositoryImpl(session).dataResume(_ticket.eventId, _ticket.id!);
    detailsData = data;
    return data;
  }

  @override
  void initState() {
    super.initState();
    session = widget.session;
    _ticket = widget.ticket;
    _ticketName = _ticket.name;
    _ticketPrice = _ticket.price;
    _ticketAmount = _ticket.amount;
    _ticketCommission = _ticket.ticketCommission ?? 0.0;
    _ticketType = _ticket.ticketsTypeEncoderName!;
    _available = _ticket.available;
    findTicketTypesListByOrganizer().then((value) => {
      setState(() {
        ticketsTypes = value;
      })
    });
  }

  Future<void> editTicket() async{
    setState(() {
      isLoading = true;
    });
    try{
      int ticketTypeId = ticketsTypes.where((element) => element.encoderName == _ticketType).first.id!;
      _ticket.name = _ticketName;
      _ticket.amount = _ticketAmount;
      _ticket.price = _ticketPrice;
      _ticket.ticketCommission = _ticketCommission;
      _ticket.ticketsTypeId = ticketTypeId;
      _ticket.available = _available;
      EventTicketsDTO ticket = await EventTicketsRepositoryImpl(session).edit(_ticket);
      setState(() {
        _ticket = ticket;
      });
    }catch(err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  _ticket.name.length > 17 ? '${_ticket.name.substring(0,17)}... ${globals.buildTicketPrice(_ticket.price)} €'  : '${_ticket.name} ${globals.buildTicketPrice(_ticket.price)} €',
                  style: GoogleFonts.nunito(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inverseSurface
                  ),
                ),
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    isEditable = !isEditable;
                  });
                },
                icon:
                const Icon(
                  Icons.edit_outlined,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: findTicketDetailsData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
                return const Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmedDataResumeWidget(),
                      ShimmedDataResumeWidget(),
                      ShimmedDataResumeWidget(),
                    ],
                  ),
                );
              }else{
                EventTicketsDetailsDTO data = snapshot.data as EventTicketsDetailsDTO;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DataResumeWidget(title: 'VENDIDAS', value: data.amountSold, icon: Icons.local_activity_outlined, color: Theme.of(context).colorScheme.onBackground),
                    DataResumeWidget(title: 'RESTANTES', value:'${data.amountRemaining}€', icon: Icons.local_activity_outlined, color: Theme.of(context).colorScheme.onBackground),
                    DataResumeWidget(title: 'INGRESOS', value: '${data.totalIncome}€', icon: Icons.euro_outlined, color: Theme.of(context).colorScheme.onBackground)
                  ],
                );
              }
            }
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(inputPaddingLeft, 15, inputPaddingRigth, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Información',
              style: GoogleFonts.nunito(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontSize: 18,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const Divider(
              endIndent: 15.0,
              indent: 15.0,
              height: 2,
          ),
          Form(
            key: _fbKey,
            autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            child: FormLayout(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(inputPaddingLeft,15,inputPaddingRigth,inputPadingBottom),
                  child: TextFormField(
                    enabled: isEditable,
                    initialValue: _ticketName,
                    onChanged: (val) {
                      _ticketName = val;
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
                        color: Theme.of(context).colorScheme.secondary
                      )
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20,0,20,15),
                  child: isEditable ?
                    DropdownButtonFormField(
                      value: _ticketType,
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
                        _ticketType = newValue.toString();
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
                        labelText: 'Tipo de Entrada',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.secondary
                        )
                      )
                    )
                  :
                  TextFormField(
                    enabled: isEditable,
                    initialValue: _ticketType,
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
                      labelText: 'Tipo de Entrada',
                      labelStyle: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.secondary
                      )
                    ),
                  ),                  
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(inputPaddingLeft,inputPaddingTop,inputPaddingRigth,inputPadingBottom),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          enabled: isEditable,
                          initialValue: _ticketPrice.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            _ticketPrice = double.parse(val);
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
                            labelText: 'Precio',
                            labelStyle: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.secondary
                            )
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.28,
                        child: TextFormField(
                          enabled: false,
                          initialValue: _ticketCommission.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            _ticketCommission = double.parse(val);
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
                            labelText: 'Comisión',
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
                        width: MediaQuery.of(context).size.width * 0.28,
                        child: TextFormField(
                          enabled: false,
                          initialValue: _ticketAmount.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            _ticketAmount = int.parse(val);
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
                            labelText: 'Cantidad',
                            labelStyle: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.secondary
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        value: _available,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.black12,
                        thumbIcon: MaterialStateProperty.resolveWith((states) => _available ? const Icon(Icons.check_outlined, color: Colors.white) : null),
                        activeColor: Colors.greenAccent,
                        activeTrackColor: Colors.black12,
                        onChanged: (bool value) {
                          if(isEditable && detailsData.amountSold == 0){
                            setState(() {
                              _available = !_available;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                isEditable ? Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.08,
                  padding: const EdgeInsets.fromLTRB(0,15,0,0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.inversePrimary),
                    ),
                    onPressed: (){
                      editTicket().then((value) {
                        CustomSnackBarWidget.openSnackBar(context, 'Sucess', 'Entradas editadas correctamente');
                        context.pop();
                      }).catchError((onError) {
                        CustomSnackBarWidget.openSnackBar(context, 'Error', 'Error editando las entradas, intentelo de nuevo.');
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
                      'GUARDAR',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.background,
                        fontWeight: FontWeight.w400
                      ),
                    )
                  ),
                ) : const SizedBox()
              ]
            )
          )
        ],
      ),
    );
  }
}