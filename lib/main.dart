import 'dart:async';
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
  Stripe.publishableKey = globals.stripePublishableKey;
  await Stripe.instance.applySettings();
  //await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
  setup();
}

void setup() async{
  await Future.delayed(const Duration(seconds: 10));
  FlutterNativeSplash.remove();
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme()
    );
  }
}