import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/request/signup_request.dart';
import 'package:my_app/infraestructure/repositories/auth_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/screens/authentication/signin_screen.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/bottomSheet/bottom_sheet_widget.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/legal/privacity_policy_widget.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final bool? showFooter;
  final String? pathTo;
  const SignupScreen({
    super.key,
    this.showFooter,
    this.pathTo
  });

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _fbKey = GlobalKey<FormState>();
  bool passVisible = false;
  bool confirmPassVisible = false;
  bool showsamePassError = false;
  bool showsPassError = false;
  bool showUserNameError = false;
  bool showEmailError = false;
  bool _emailNotValid = false;
  bool _userNameNotValid = false;
  final bool _autovalidate = false;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode userNameFocusNode = FocusNode();

  Future<bool> validateNonDuplicatedEmail() async {
    bool res = await AuthenticationRepositoryImpl(null).validateUniqueEmail(_emailController.text);
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

  Future<bool> validateAvailableUserName() async {
    bool res = await AuthenticationRepositoryImpl(null).validateAvailableUserName(_userNameController.text);
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

  @override
  void initState() {
    super.initState();

    userNameFocusNode.addListener(() {
      if(_userNameController.text != ''){
        validateAvailableUserName();
      }
    });
    emailFocusNode.addListener(() {
      if(_emailController.text != ''){
        validateNonDuplicatedEmail();
      }
    });
  }
  

  Future<JwtAuthenticationResponseDTO> submitSignUp() async {
    SignUpRequest signUpRequest = SignUpRequest(
      userName: _userNameController.text, 
      password: _passController.text,
      email: _emailController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,      
    );

    JwtAuthenticationResponseDTO response = await AuthenticationRepositoryImpl(null).signUp(signUpRequest);
    return response;
  }
  void navigateTo(JwtAuthenticationResponseDTO value) {
    if (widget.pathTo != null) {
      List<String> parts = widget.pathTo!.split("/");
      var eventId = parts.elementAt(2);
      var publicRelationCode = parts.elementAt(3);
      context.goNamed("event_details", pathParameters: {"id": eventId, "publicRelationCode": publicRelationCode, "assigned": 'N'});
    } else {
      switch(value.user.roleCode) {
        case 'RRPP':
          context.goNamed('event_home_rrpp');
          break;
        case 'ADMIN':
          context.goNamed('event_home');
          break;
        case 'USER':
          context.goNamed('event_home_user');
          break;
      }
    }
  }

    Widget buildTitleSpace(){
    if(widget.showFooter != null && widget.showFooter == false){
      return ListTile(
        leading: IconButton(
          onPressed: (){
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const TextIconWidget(size: 65),
      );
    }else{
      return Column(
        children: [
          SizedBox(
                height:  MediaQuery.of(context).size.height * 0.05,
          ),
          const TextIconWidget(size: 65),
          SizedBox(
                height:  MediaQuery.of(context).size.height * 0.025,
          ),
        ]
      );
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    ref.listen(
    sessionProvider,
    ((previous, next) => {
      if(next.session != null) {
        context.go(next.session!.user.roleCode == 'RRPP' ? '/homeRRPP' : '/home')
      }
    })
   );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            buildTitleSpace(),          
            Form(
              key: _fbKey,
              autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: FormLayout(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _userNameController,
                    focusNode: userNameFocusNode,
                    validator: (value) {
                      if(_userNameController.text == '' || !_userNameController.text.startsWith('@')){
                        Future.delayed(Duration.zero, () => {setState(() => showEmailError = true)});
                        return "El usuario debe empezar por @.";
                      }
                      if(_userNameController.text != '' && _userNameNotValid) {
                        return 'El usuario en uso, prueba otro.';                      
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
                      labelText: 'Usuario',
                      labelStyle: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.onBackground
                      )
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    elevation: 5.0,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    child: TextFormField(
                      controller: _firstNameController,
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
                        labelText: 'Nombre',
                        labelStyle: GoogleFonts.nunito(
                          color: Theme.of(context).colorScheme.onBackground
                        )
                      ),
                    ),
                  ),
                ),                
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _lastNameController,
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
                      labelText: 'Apellidos',
                      labelStyle: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.onBackground
                      )
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _emailController,
                    focusNode: emailFocusNode,
                    onChanged: (val) {
                      _fbKey.currentState!.validate();                      
                    },
                    validator: (value) {
                      if(value == null || !RegExp(r'\S+@\S+\.\S+').hasMatch(value) || _emailNotValid){
                        Future.delayed(Duration.zero, () => {setState(() => showEmailError = true)});
                        return "Correo inválido";
                      } else {
                        return null;
                      }
                    },
                    onTapOutside: (value) {
                      if(RegExp(r'\S+@\S+\.\S+').hasMatch(_emailController.text)) {
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Correo Electrónico',
                      labelStyle: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.onBackground
                      )
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: !passVisible,              
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          passVisible ? 
                          Icons.visibility : 
                          Icons.visibility_off,
                          color: Theme.of(context).colorScheme.secondary,  
                        ),
                        onPressed: () {
                          setState(() {
                            passVisible = !passVisible;
                          });
                        },
                      ),
                      labelText: 'Contraseña',
                      labelStyle: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.onBackground
                      )
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _confirmPassController,
                    obscureText: !confirmPassVisible,
                    onChanged: (val) => {
                      setState(() {
                        showsamePassError = false;
                      })  
                    },
                    validator: (value) {
                      if( (_passController.text != '' && _confirmPassController.text != '') && (_passController.text != _confirmPassController.text)){
                        Future.delayed(
                          Duration.zero,
                          () => {setState(() => showsamePassError = true)}
                        );
                        return 'Las contraseñas no son iguales';
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          confirmPassVisible ? 
                          Icons.visibility : 
                          Icons.visibility_off,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          setState(() {
                            confirmPassVisible = !confirmPassVisible;
                          });
                        },
                      ),
                      labelText: 'Confirm password',
                      labelStyle: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.onBackground
                      )
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        label: Text(
                          'Finalizar',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary
                        ),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,  
                        ),
                        onPressed: () {
                          if(_fbKey.currentState!.validate()){
                            submitSignUp().then((value) => navigateTo(value));
                          }
                        }
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Column(                  
                  children: [
                    Text(
                      "Al completar el registro estas de acuerdo con los ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        BottomSheetWidget.showModalBottomSheet(
                          context, 
                          const PrivacityPolicyWidget(), 
                          MediaQuery.of(context).size.height * 0.8,
                          MediaQuery.of(context).size.height * 0.5,
                          null,
                          null
                        );
                      },
                      child: Text(
                        "términos de política y privacidad",
                        style:  GoogleFonts.nunito(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    
                  ],
                ),
                widget.showFooter != null && widget.showFooter == false ?
                const SizedBox()
                :
                Column(
                  children: [
                    Text(
                      "o",
                      textAlign: TextAlign.center,
                      style:  GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.background
                      ),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/googleIcon_image.png") )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ya tienes una cuenta ?',
                          style:  GoogleFonts.nunito(
                            color: Theme.of(context).textTheme.bodyMedium?.color
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) => 
                              Theme.of(context).buttonTheme.colorScheme?.secondary
                            )
                          ),
                          child: Text(
                            'Inicia Sesión!',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background
                            ),
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const SignInScreen();
                            }));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            )
          )
          ],
        ),
      ),
    );
  }
}