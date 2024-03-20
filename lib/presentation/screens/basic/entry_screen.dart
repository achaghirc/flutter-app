import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/authentication/jwt_authentication_response_dto.dart';
import 'package:my_app/presentation/providers/auth_provider.dart';
import 'package:my_app/presentation/screens/authentication/signin_screen.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;
class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key});

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  //DEEP LINKING
  Object? _err;
  StreamSubscription? _sub;

  Future<JwtAuthenticationResponseDTO?> getSessionUser(String key) async{
    String? strSession = await secureStorage.read(key: key);
    if(strSession == null){
      return null;
    }else{
      JwtAuthenticationResponseDTO session = JwtAuthenticationResponseDTO.fromJson(jsonDecode(strSession));
      return session;
    }
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        context.pushNamed(uri!.path);
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }
 ///outnow://achaghirc.github.io/signin
  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      print('_handleInitialUri called');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }


  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
    getSessionUser("session").then((session) => {
      if(session != null){
        ref.read(sessionProvider.notifier).set(session),
        if(session.user.roleCode == 'RRPP'){
          context.goNamed('event_home_rrpp'),
        }else{
          context.goNamed('event_home'),
        },
      }
    });
  }
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        //color: Theme.of(context).colorScheme.background,
        child: CustomPaint(
          painter: _HeaderDiagonalPainter(context),
          child: Stack(
          children: [            
            const Center(
              child: TextIconWidget()
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.44,
              left: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                 "TICKETS",
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                            label:  Text(
                              "Comenzar",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 20
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const SignInScreen();
                          }));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aún no tienes una cuenta ?',
                        style: GoogleFonts.nunito(),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) => 
                          Theme.of(context).buttonTheme.colorScheme?.inversePrimary ?? Colors.grey
                          )
                        ),
                        child: Text(
                          'Registrate!',
                          style: GoogleFonts.nunito(),
                        ),
                        onPressed: (){
                          GoRouter.of(context).go('/signup');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 20,
                  ),
                ],
              ),
            ),
          ]),
      ),
    ),
    );
  }
}



class _HeaderDiagonalPainter extends CustomPainter {
  late BuildContext context;
  _HeaderDiagonalPainter(this.context);


  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final paint = Paint();

    paint.color = Theme.of(context).colorScheme.inversePrimary;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 5;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}