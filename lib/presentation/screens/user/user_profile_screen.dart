import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/providers/theme_provider.dart';
import 'package:my_app/presentation/screens/screens.dart';
import 'package:my_app/presentation/screens/user/change_password_screen.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';




class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    late bool isDarkMode = false;
    late JwtAuthenticationResponseDTO session;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(ref.read(sessionProvider).session == null){
      context.pushReplacementNamed('signin');
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future deleteSessionUser() async{
    await secureStorage.delete(key: 'session');
  }
  
  @override
  Widget build(BuildContext context) {
    session = ref.watch(sessionProvider).session!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Perfil",
          style: GoogleFonts.nunito(
            color: Theme.of(context).textTheme.titleMedium?.color,
            fontSize: 25,
            fontWeight: FontWeight.w300
          ),
        ),
        actions: [
           Padding(
             padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
             child: Switch(
               value: isDarkMode,
               inactiveThumbColor: Colors.yellow,
               inactiveTrackColor: Theme.of(context).colorScheme.surface,
               thumbIcon: MaterialStateProperty.resolveWith((states) => 
                isDarkMode ? const Icon(Icons.nightlight_outlined, color: Colors.white) : const Icon(Icons.sunny) 
               ),
               activeColor: Theme.of(context).colorScheme.primary,
               activeTrackColor: Theme.of(context).colorScheme.surface,
               onChanged: (bool value) {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
                 ref.read(themeNotifierProvider.notifier).toggleDarkMode();
               },
             ),
           )
        ],
      ),
      body: ListView(
        children: [
          CircleAvatar(
            radius: 52,
              backgroundColor: Colors.white, // Image radius
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),  
                child: Image.asset('assets/userIcons/menProfile.png'),
              ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Text(
                session.user.personName ,
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.w600
                ),
              ),
              Text(
                session.user.username,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w300
                ),  
              ),
            ],
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserPersonalDataScreen(session: session);
              }));
            },
            title: Text(
              'Datos Personales',
              style: GoogleFonts.nunito(),
              ),
            trailing:  Wrap(
              spacing: 5,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).iconTheme.color,
                )
              ]
            ),
          ),
          const Divider(
            color: Colors.black12,
            endIndent: 20.0,
            indent: 20.0,
            height: 2,
          ),
          ListTile(
            onTap: (){
              context.pushNamed('payment_methods');
            },
            title: Text(
              'Formas de Pago',
              style: GoogleFonts.nunito(),
              ),
            trailing:  Wrap(
              spacing: 5,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).iconTheme.color,
                )
              ]
            ),
          ),
          const Divider(
            color: Colors.black12,
            endIndent: 20.0,
            indent: 20.0,
            height: 2,
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChangePasswordScreen(session: session);
              }));
            },
            title: Text(
              'Cambiar Contraseña',
              style: GoogleFonts.nunito(),
              ),
            trailing:  Wrap(
              spacing: 5,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).iconTheme.color,
                )
              ]
            ),
          ),
          // const Divider(
          //   color: Colors.black12,
          //   endIndent: 20.0,
          //   indent: 20.0,
          //   height: 2,
          // ),
          // ListTile(
          //   onTap: (){},
          //   title: Text(
          //     'Devoluciones',
          //     style: GoogleFonts.nunito(),
          //     ),
          //   trailing:  Wrap(
          //     spacing: 5,
          //     children: [
          //       Icon(
          //         Icons.arrow_forward,
          //         color: Theme.of(context).iconTheme.color,
          //       )
          //     ]
          //   ),
          // ),
          const Divider(
            color: Colors.black12,
            endIndent: 20.0,
            indent: 20.0,
            height: 2,
          ),
          ListTile(
            onTap: (){},
            title: Text(
              'Eliminar Cuenta',
              style: GoogleFonts.nunito(),
              ),
            trailing:  Wrap(
              spacing: 5,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).iconTheme.color,
                )
              ]
            ),
          ),
          const Divider(
            color: Colors.black12,
            endIndent: 20.0,
            indent: 20.0,
            height: 2,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.95,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).buttonTheme.colorScheme!.secondary)
              ),
              onPressed: () {
                deleteSessionUser();
                ref.read(sessionProvider).clear();
                context.pushReplacementNamed('signin');
              }, 
              child: Text(
                'Cerrar Session',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300  
                ),
              )
            )
          ),
          const SizedBox(
            height: 25,
          ),
          Column(
            children: [
              const TextIconWidget(),
              Text(
                'Version 0.0.1',
                style: GoogleFonts.nunito(
                  fontStyle: FontStyle.italic
                ),
              ),
              Text(
                'Información Legal',
                style: GoogleFonts.nunito(),
                ),
            ],
          ),
        ]
      )
    );
  }
}