import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/request/signin_request.dart';
import 'package:my_app/infraestructure/repositories/auth_repository_impl.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/screens/authentication/signup_screen.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignInScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final _fbKey = GlobalKey<FormState>();
  late String userName = '';
  late String password = '';
  late bool passVisible = false;
  final bool _autovalidate = false;
  bool isLoading = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future setSessionUser(JwtAuthenticationResponseDTO session) async{
    await secureStorage.write(key: "session", value: jsonEncode(session.toJson()));
  }


  Future<JwtAuthenticationResponseDTO> submitLogin() async {
    setState(() {
      isLoading = true;
    });
    SignInRequest signInRequest = SignInRequest(userName: userName, password: password);
    JwtAuthenticationResponseDTO response = await AuthenticationRepositoryImpl(null).signIn(signInRequest);

    isLoading = false;
    ref.read(sessionProvider.notifier).set(response);
    setSessionUser(response);
    return response;
  }

  @override
  void initState() {
    super.initState();
    if(ref.read(sessionProvider).session?.token != null){
      context.push('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
   
   return Scaffold(
      body: SafeArea(
        child: PopScope(
          canPop: false,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const TextIconWidget(size: 65),
              const SizedBox(
                height: 10,
              ),         
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.lock_open_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.surface
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Form(
                key: _fbKey,
                autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                child: FormLayout(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Material(
                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                        elevation: 5.0,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        child: TextFormField(
                          controller: userNameController,
                          onChanged: (val) {
                            userName = val.trim();
                          },
                          validator: (value) {
                              if(value == ''){
                                return 'Username obligatorio';
                              }
                              return null;
                          },
                          decoration: InputDecoration(
                            focusColor: Theme.of(context).colorScheme.secondary,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                            )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'User Name',
                            labelStyle: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.onBackground
                            )
                          ),
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
                          controller: passwordController,
                          obscureText: !passVisible,
                          cursorColor: Theme.of(context).colorScheme.primary,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            password = val;
                          },
                          validator: (value) {
                              if(value == ''){
                                return 'Contraseña obligatoria';
                              }
                              return null;
                          },
                          style: GoogleFonts.nunito(),
                          decoration: InputDecoration(
                            focusColor: Theme.of(context).colorScheme.secondary,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              )
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.onBackground
                            )
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
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
                                  'Iniciar Sesión',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                              )
                          ),
                          onPressed: (){
                            if(_fbKey.currentState!.validate()) {
                                submitLogin().then((value) => 
                                context.go(value.user.roleCode == 'RRPP' ? '/homeRRPP' : '/home')
                              ).catchError((onError) => {
                                setState(() => 
                                  isLoading = false
                                ),
                                CustomSnackBarWidget.openSnackBar(context, 'Error', 'Usuario o contraseña incorrectos.'),
                                if(kDebugMode){
                                  print(onError.toString())
                  
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
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
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Aún no tienes una cuenta ?',
                          style: GoogleFonts.nunito(
                              color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) => 
                            Theme.of(context).buttonTheme.colorScheme?.secondary ?? Colors.grey
                            )
                          ),
                          child: Text(
                            'Registrate!',
                            style: GoogleFonts.nunito(
                              color: Theme.of(context).colorScheme.background
                            ),  
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const SignupScreen();
                            }));
                          },
                        ),
                      ],
                    ),
                  ]
                )
              ),
              Center(
                child: Text(
                  'Version 0.0.1',
                  style: GoogleFonts.nunito(
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ]
          ),
        ),
      )
   );
  }
}