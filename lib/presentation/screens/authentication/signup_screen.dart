
// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/request/signup_request.dart';
import 'package:my_app/infraestructure/repositories/auth_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/screens/authentication/signin_screen.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _fbKey = GlobalKey<FormState>();
  String userName = "";
  String email = "";
  String password = "";
  String confirmPass = "";
  bool passVisible = false;
  bool confirmPassVisible = false;
  bool showsamePassError = false;
  bool showsPassError = false;
  bool showUserNameError = false;
  bool showEmailError = false;
  bool _emailNotValid = false;
  bool _userNameNotValid = false;
  bool _autovalidate = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode userNameFocusNode = FocusNode();

  Future<bool> validateNonDuplicatedEmail() async {
    bool res = await AuthenticationRepositoryImpl(null).validateUniqueEmail(email);
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
    bool res = await AuthenticationRepositoryImpl(null).validateAvailableUserName(userName);
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
      if(userName != ''){
        validateAvailableUserName();
      }
    });
    emailFocusNode.addListener(() {
      if(email != ''){
        validateNonDuplicatedEmail();
      }
    });
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const TextIconWidget(),           
            Form(
              key: _fbKey,
              autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              child: FormLayout(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: nameController,
                    focusNode: userNameFocusNode,
                    onChanged: (val) {
                      userName = val;
                    },
                    validator: (value) {
                      if(userName == '' || !userName.startsWith('@')){
                        Future.delayed(Duration.zero, () => {setState(() => showEmailError = true)});
                        return "El usuario debe empezar por @.";
                      }
                      if(userName != '' && _userNameNotValid) {
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
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        onChanged: (val) {
                          _fbKey.currentState!.validate();
                          Future.delayed(Duration.zero, 
                          () => {
                            setState(() {
                                email = val;
                            })
                          }
                          );
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
                          if(RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
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
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: passController,
                    obscureText: !passVisible,
                    onChanged: (val) {
                      password = val;
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
                    controller: confirmPassController,
                    obscureText: !confirmPassVisible,
                    onChanged: (val) => {
                      setState(() {
                        showsamePassError = false;
                        confirmPass = val;
                      })  
                    },
                    validator: (value) {
                      if( (password != '' && confirmPass != '') && (password != confirmPass)){
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
                          'Siguiente',
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
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SecondSignUpPage(prevSignUpFiels: SignUpRequest(userName: userName, firstName: "", lastName: "", email: email, password: password, dni: "", phoneNumber: ""));
                                }
                              )
                            );
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
                      "Al iniciar sesión estas de acuerdo con los ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    Text(
                      "términos de política y privacidad",
                      textAlign: TextAlign.center,
                      style:  GoogleFonts.nunito(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
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
                    )
                  ],
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
            )
          )
          ],
        ),
      ),
    );
  }
}

class SecondSignUpPage extends ConsumerStatefulWidget {
  final SignUpRequest prevSignUpFiels;

  const SecondSignUpPage({
    super.key, 
    required this.prevSignUpFiels
  });

  @override
  ConsumerState<SecondSignUpPage> createState() => _SecondSignUpPageState();
}

class _SecondSignUpPageState extends ConsumerState<SecondSignUpPage> {
  
  late String firstName;
  late String lastName;
  late String dni;
  late String phoneNumber;

  late bool _validData = true;
  
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _dniController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  late SignUpRequest signUpRequest;


  submitSignUp() {
    signUpRequest.dni = dni;
    signUpRequest.firstName = firstName;
    signUpRequest.lastName = lastName;
    signUpRequest.phoneNumber = phoneNumber;

    AuthenticationRepositoryImpl(null).signUp(signUpRequest).then((value) { 
      ref.read(sessionProvider.notifier).set(value);
      context.push('/home');
    }).catchError((error) {
        print(error.toString());
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstName = "";
    lastName = "";
    dni = "";
    phoneNumber = "";
    signUpRequest = widget.prevSignUpFiels;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                const TextIconWidget(),
                Text(
                  'Cuentanos más sobre ti...',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),  
            Container(
              padding: const EdgeInsets.all(10),
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                elevation: 5.0,
                shadowColor: Colors.grey.withOpacity(0.5),
                child: TextFormField(
                  controller: _firstNameController,
                  onChanged: (val) {
                    firstName = val;
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
                onChanged: (val) {
                  lastName = val;
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
                controller: _dniController,
                onChanged: (val) {
                  dni = val;
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
                  labelText: 'DNI/NIE/CIF',
                  labelStyle: GoogleFonts.nunito(
                    color: Theme.of(context).colorScheme.onBackground
                  )
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _phoneNumberController,
                onChanged: (val) => {
                  setState(() {
                    phoneNumber = val;
                  })  
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
                  labelText: 'Teléfono',
                  labelStyle: GoogleFonts.nunito(
                    color: Theme.of(context).colorScheme.onBackground
                  )
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.secondary)
                ),
                child: Text(
                  'Finalizar',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.background
                  )
                ),
                onPressed: (){
                  if(_validData){
                    submitSignUp();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}