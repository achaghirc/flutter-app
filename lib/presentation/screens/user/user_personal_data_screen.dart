import 'package:country_flags/country_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/user_dto.dart';
import 'package:my_app/infraestructure/repositories/auth_repository_impl.dart';
import 'package:my_app/infraestructure/repositories/queryFilters/search_users_query_params.dart';
import 'package:my_app/infraestructure/repositories/user_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';


class UserPersonalDataScreen extends ConsumerStatefulWidget {
  final JwtAuthenticationResponseDTO session;
  const UserPersonalDataScreen({
    super.key,
    required this.session
  });

  @override
  ConsumerState<UserPersonalDataScreen> createState() => _UserPersonalDataScreenState();
}

class _UserPersonalDataScreenState extends ConsumerState<UserPersonalDataScreen> {
  final _fbKey = GlobalKey<FormState>();
  bool showEmailError = false;
  bool _emailNotValid = false;
  bool _userNameNotValid = false;
  late UserDTO user;
  late String _actualUsername;
  late String _actualEmail;
  late bool isLoading = false;
  final bool _autovalidate = false;
  
  FocusNode emailFocusNode = FocusNode();
  FocusNode userNameFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = UserDTO.fromJson({});
    userNameFocusNode.addListener(() {
      if(user.username != '' && _actualUsername != user.username){
        validateAvailableUserName();
      }
    });
    emailFocusNode.addListener(() {
      if(user.person.email != '' && _actualEmail != user.person.email){
        validateNonDuplicatedEmail();
      }
    });
  }
  
  void onChangeDo(value, label) {
    switch(label) {
      case 'Usuario': 
        user.username = value;
        break;
      case 'Nombre':
        user.person.name = value;
        break;
      case 'Apellidos':
        user.person.lastName = value;
        break;
      case 'Email':
        user.person.email = value;
        break;
      case 'Móvil':
        user.person.phoneNumber = value;
        break;
    }
  }

  Future<UserDTO> submitChanges() async {
    try{
      setState(() {
        isLoading = true;
      });
      UserDTO newUser = await UserRepositoryImpl(widget.session).updateUser(user);

      if(user.id != null){
        JwtAuthenticationResponseDTO session = widget.session;
        session.user.personEmail = newUser.person.email;
        session.user.personName = newUser.person.name;
        session.user.username = newUser.username;
        ref.read(sessionProvider.notifier).set(session);
      }

      return newUser;
    }catch (e) {
      if(kDebugMode){
        print(e);
      }
      throw 'Ha ocurrido un problema actualizando su perfil';
    }
  }

  Future<UserDTO> findUser() async{
    if(user.id == null){
      List<UserDTO> userList =  await UserRepositoryImpl(widget.session).searchUser(SearchUsersQueryParams(id: int.parse(widget.session.user.id)));
      if(userList.isEmpty){
        throw "No user found";
      }
      user = userList.first;
      _actualEmail = user.person.email;
      _actualUsername = user.username;
      return userList.first;
    }else {
      return user;
    }
  }

  Future<bool> validateAvailableUserName() async {
    bool res = await AuthenticationRepositoryImpl(null).validateAvailableUserName(user.username);
    if(!res) {
      setState( () {
        _userNameNotValid = true;
        _fbKey.currentState!.validate();
      });
      return res;
    } else{
      setState( () {
        _userNameNotValid = false;
        _fbKey.currentState!.validate();
      });
      return res;
    }
  }

  Future<bool> validateNonDuplicatedEmail() async {
      bool res = await AuthenticationRepositoryImpl(null).validateUniqueEmail(user.person.email);
      if(!res) {
        setState( () {
          _emailNotValid = true;
          _fbKey.currentState!.validate();
        });
        return res;
      } else{
        setState( () {
          _emailNotValid = false;
          _fbKey.currentState!.validate();
        });
        return res;
      }
  }

  String? inputFormValidation(String? value, String labelText){
    if(labelText == 'Email'){
      if(value == null || !RegExp(r'\S+@\S+\.\S+').hasMatch(value) || _emailNotValid){
        Future.delayed(Duration.zero, () => {setState(() => showEmailError = true)});
        return "Correo inválido, o no disponible";
      }
    }
    return null;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: findUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.data == null) {
            return Center(
              child: Text(
                'Ha ocurrido algún problema recuperando el usuario',
                style: GoogleFonts.nunito(),
              ),
            );
          }else{
            UserDTO user = snapshot.data as UserDTO;
            return ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Center(
                  child: Stack(
                    children:  [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.onBackground, shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white, // Image radius
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),  
                            child: user.image != null  ? Image.memory(user.image!.data) : Image.asset('assets/userIcons/menProfile.png')
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -10,
                        child: ElevatedButton(
                          onPressed: () {
                            BottomSheetWidget.showModalBottomSheet(context, 
                            _ChangeImageWidget(session: widget.session), 
                            MediaQuery.of(context).size.height * 0.3, 
                            MediaQuery.of(context).size.height * 0.3,
                            null, null);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            size: 20,
                            color: Colors.white,                        
                          ),
                        )
                      )
                    ]
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _fbKey,
                  autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  child: FormLayout(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          initialValue: user.username,
                          keyboardType:  TextInputType.text,
                          focusNode: userNameFocusNode,
                          onChanged: (val) {
                            user.username = val;
                          },
                          validator: (value) {
                              if(value == ''){
                                return 'Campo obligatorio';
                              }
                              if(value != '' && !user.username.startsWith('@')){
                                Future.delayed(Duration.zero, () => {setState(() => showEmailError = true)});
                                return "El usuario debe empezar por @.";
                              }
                              if(user.username != '' && _userNameNotValid) {
                                return 'El usuario en uso, prueba otro.';                      
                              }
                              return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_2_outlined),
                            focusColor: Theme.of(context).colorScheme.secondary,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                            )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'Usuario',
                            labelStyle: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.onBackground
                            )
                          ),
                        ),
                      ),
                      _ContainerInputField(initialValue: user.person.name, labelText: 'Nombre', onChangeDo: (value, label) =>  onChangeDo(value, label), icon: Icons.person_2_outlined, keyboardType: TextInputType.text,),
                      _ContainerInputField(initialValue: user.person.lastName, labelText: 'Apellidos', onChangeDo: (value, label) =>  onChangeDo(value, label), icon: Icons.person_2_outlined, keyboardType: TextInputType.text,),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          initialValue: user.person.email,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: emailFocusNode,
                          onChanged: (val) {
                            _fbKey.currentState!.validate();
                            Future.delayed(Duration.zero, 
                            () => {
                              setState(() {
                                  user.person.email = val;
                              })
                            }
                            );
                          },
                          validator: (value) {
                            if(value == null || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)){
                              return "Correo inválido";
                            } else if(_actualEmail != user.person.email && _emailNotValid) {
                              return "Correo en uso en la plataforma.";
                            }
                            return null;
                          },
                          onTapOutside: (value) {
                            if(RegExp(r'\S+@\S+\.\S+').hasMatch(user.person.email)) {
                              validateNonDuplicatedEmail();
                              _fbKey.currentState!.validate();
                            }
                          },
                          decoration: InputDecoration(
                            focusColor: Theme.of(context).colorScheme.secondary,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.secondary,
                              )
                            ),
                            prefixIcon: const Icon(Icons.alternate_email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'Correo Electrónico',
                            labelStyle: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.onBackground
                            )
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          initialValue: '${user.person.phoneNumber}',
                          keyboardType: TextInputType.phone,
                          onChanged: (val) {
                            _fbKey.currentState!.validate();
                            Future.delayed(Duration.zero, 
                            () => {
                              setState(() {
                                  user.person.phoneNumber = int.parse(val);
                              })
                            }
                            );
                          },
                          validator: (value) {
                            if(value == null || !RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{3}$').hasMatch(value)){
                              return "Teléfono inválido";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            focusColor: Theme.of(context).colorScheme.secondary,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.secondary,
                              )
                            ),
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'Móvil',
                            labelStyle: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.onBackground
                            )
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary
                            ),
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
                                    'Guardar',
                                    style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                )
                            ),
                            onPressed: (){
                              if(_fbKey.currentState!.validate()) {
                                  submitChanges().then((value) => context.pop()
                                ).catchError((onError) => {
                                  setState(() => 
                                    isLoading = false
                                  ),
                                  CustomSnackBarWidget.openSnackBar(context, 'Error', 'Error actualizando su perfil, intentelo de nuevo.'),
                                  if(kDebugMode){
                                    print(onError.toString())
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ]
                  )
                )
              ],
            );
          }
        },
        
      ),
    );
  }
}


class _ChangeImageWidget extends StatelessWidget {
  final JwtAuthenticationResponseDTO session;
  const _ChangeImageWidget({
    super.key,
    required this.session
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        Text(
          'Tu foto de perfil  podrá ser visualizada por ti y por todos los organizadores \n que te contraten, o se encuentren en busqueda de usuarios para contratar.',
          style: GoogleFonts.nunito(
            fontSize: 10
          ),
        ),
        const Divider(
          height: 10,
          indent: 10,
          endIndent: 10,
        ),
        ListTile(
          onTap: () {
            print('ELEGIR DE LA BIBLIOTECA');
          },
          horizontalTitleGap: 10.0,
          leading: const Icon(
            Icons.image_outlined
          ),
          title: Text(
            'Elegir de la biblioteca',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700
            ),
          ),
        ),
        ListTile(
          onTap: () {
            print('HACER UNA FOTO');
          },
          horizontalTitleGap: 10.0,
          leading: const Icon(
            Icons.camera_alt_outlined
          ),
          title: Text(
            'Hacer una foto',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700
            ),
          ),
        ),
        ListTile(
          onTap: () {
            print('ELIMINAR FOTO ACTUAL');
          },
          horizontalTitleGap: 10.0,
          leading: const Icon(
            Icons.delete_outline_outlined,
            color: Colors.red,
          ),
          title: Text(
            'Eliminar foto actual',
            style: GoogleFonts.nunito(
              color: Colors.red,
              fontWeight: FontWeight.w700
            ),
          ),
        ),
      ],
    );
  }
}

class _ContainerInputField extends StatefulWidget {
  final String initialValue;
  final String labelText;
  final IconData icon;
  final Function onChangeDo;
  final TextInputType keyboardType;
  
  const _ContainerInputField({
    required this.initialValue,
    required this.labelText,
    required this.icon,
    required this.onChangeDo,
    required this.keyboardType,
  });

  @override
  State<_ContainerInputField> createState() => _ContainerInputFieldState();
}

class _ContainerInputFieldState extends State<_ContainerInputField> {
  bool showEmailError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();  
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        initialValue: widget.initialValue,
        keyboardType:  widget.keyboardType,
        onChanged: (val) {
          widget.onChangeDo(val, widget.labelText);
        },
        validator: (value) {
            if(value == ''){
              return '${widget.labelText} obligatorio';
            }
            return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          focusColor: Theme.of(context).colorScheme.secondary,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
          )),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: widget.labelText,
          labelStyle: GoogleFonts.nunito(
            color: Theme.of(context).colorScheme.onBackground
          )
        ),
      ),
    );
  }
}