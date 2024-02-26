import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/infraestructure/models/authentication/request/change_password.dart';
import 'package:my_app/infraestructure/repositories/user_repository_impl.dart';
import 'package:my_app/shared/form/form_layout.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:my_app/shared/widgets/snackBar/custom_snackbar_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  final JwtAuthenticationResponseDTO session;
  const ChangePasswordScreen({
    super.key,
    required this.session
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _fbKey = GlobalKey<FormState>();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController newPassController = TextEditingController();
  late TextEditingController newPassConfirmController = TextEditingController();
  late bool isLoading = false;
  bool showsamePassError = false;
  bool showPassword = false;
  bool showNewPassword = false;
  bool showPassConfirmPassword = false;
  final bool _autovalidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    bool checkSamePassword() {
      if( (newPassController.text != '' && newPassConfirmController.text != '') 
            && (newPassController.text != newPassConfirmController.text)){
        return false;
      }
      return true;
    }

    Future<bool> submitChangePassword() async {
      setState(() {
        isLoading = true;
      });
      bool checkPasswordSame = checkSamePassword();
      if(!checkPasswordSame){
        setState(() {
          isLoading = false;
        });
        return Future.value(false);
      }else{
        ChangePasswordDTO changePasswordDTO = ChangePasswordDTO(userId: widget.session.user.id, oldPassword: passwordController.text, newPassword: newPassController.text);
        bool res = await UserRepositoryImpl(widget.session).changePassword(changePasswordDTO);
        setState(() {
          isLoading = false;
        });
        return res;
      }
      
    }



    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cambiar Contraseña',
          style: GoogleFonts.nunito()
        ),
      ),
      body: Column(
        children: [
          const TextIconWidget(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Form(
            key: _fbKey,
            autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            child: FormLayout(
              children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  onChanged: (val) {
                    
                  },
                  validator: (value) {
                      if(value == ''){
                        return 'Campo obligatorio';
                      }               
                      return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password_outlined),
                    focusColor: Theme.of(context).colorScheme.secondary,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                    )),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                          
                        });
                      },
                      icon: Icon(
                        showPassword ? 
                        Icons.visibility : Icons.visibility_off
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Contraseña Antigua',
                    labelStyle: GoogleFonts.nunito(
                      color: Theme.of(context).colorScheme.onBackground
                    )
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: newPassController,
                  obscureText: !showNewPassword,
                  onChanged: (val) {
                    
                  },
                  validator: (value) {
                      if(value == ''){
                        return 'Campo obligatorio';
                      }               
                      return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    focusColor: Theme.of(context).colorScheme.secondary,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                    )),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showNewPassword = !showNewPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? 
                        Icons.visibility : Icons.visibility_off
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Contraseña Nueva',
                    labelStyle: GoogleFonts.nunito(
                      color: Theme.of(context).colorScheme.onBackground
                    )
                  ),
                ),
              ),              
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: newPassConfirmController,
                  obscureText: !showPassConfirmPassword,
                  onChanged: (val) {
                    
                  },
                  validator: (value) {                  
                      if( (newPassController.text != '' && newPassConfirmController.text != '') 
                          && (newPassController.text != newPassConfirmController.text)){
                        Future.delayed(
                          Duration.zero,
                          () => {setState(() => showsamePassError = true)}
                        );
                        return 'Las contraseñas no son iguales';
                      }
                      return null;              
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    focusColor: Theme.of(context).colorScheme.secondary,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                    )),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassConfirmPassword = !showPassConfirmPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? 
                        Icons.visibility : Icons.visibility_off
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Confirma Contraseña',
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
                          submitChangePassword().then((value) => {
                            if(value){
                              CustomSnackBarWidget.openSnackBar(context, 'Success', 'Contraseña actualizada correctamente'),
                            }else{
                              CustomSnackBarWidget.openSnackBar(context, 'Error', 'Ha ocurrido un error actualizando la contraseña')
                            },                                            
                          }
                        );
                      }
                    },
                  ),
                ),
              ),
              ]
            )
          )
        ],
      ),
    );
  }
}

class _ContainerPassword extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final IconData icon;
  const _ContainerPassword({
    super.key,
    required this.labelText,
    required this.controller,
    required this.icon
  });

  @override
  State<_ContainerPassword> createState() => __ContainerPasswordState();
}

class __ContainerPasswordState extends State<_ContainerPassword> {
  late bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: widget.controller,
        obscureText: !showPassword,
        onChanged: (val) {
          
        },
        validator: (value) {
            if(value == ''){
              return 'Campo obligatorio';
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
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
                
              });
            },
            icon: Icon(
              showPassword ? 
              Icons.visibility : Icons.visibility_off
            ),
          ),
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