import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_app/config/theme/app_theme.dart';
import 'package:my_app/presentation/providers/theme_provider.dart';
import 'package:my_app/presentation/router/router_app.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  if(!kIsWeb){
    Stripe.publishableKey = globals.stripePublishableKey;
    await Stripe.instance.applySettings();
    //await Firebase.initializeApp();
  }
  runApp(const ProviderScope(child: MyApp()));
  setup();
}

void setup() async{ 
  if(!kIsWeb){
    await Future.delayed(const Duration(seconds: 4));
  }
  FlutterNativeSplash.remove();
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme()
    );
  }
}