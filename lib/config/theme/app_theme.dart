
import 'package:flutter/material.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';



const Color primarySeedColor = Color(0xFF26547C);
const Color secondarySeedColor = Color(0xFF8AC5F8);
const Color tertiarySeedColor = Color(0xFF06D6A0);

final ColorScheme schemeLight = SeedColorScheme.fromSeeds(
    brightness: Brightness.light,
    primaryKey: primarySeedColor,
    secondaryKey: secondarySeedColor,
    tertiaryKey: tertiarySeedColor,
    tones: FlexTones.vivid(Brightness.light),
    surfaceTint: primarySeedColor
);


final ColorScheme schemeDark = SeedColorScheme.fromSeeds(
    brightness: Brightness.dark,
    primaryKey: primarySeedColor,
    secondaryKey: secondarySeedColor,
    tertiaryKey: tertiarySeedColor,
    tones: FlexTones.vivid(Brightness.dark),
    surfaceTint: primarySeedColor
);

class AppTheme {

  final bool isDarkMode;

  AppTheme({
    this.isDarkMode = true,
  });


  AppTheme copyWith({bool? isDarkMode}) => AppTheme(
    isDarkMode: isDarkMode ?? this.isDarkMode
  );

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorScheme: isDarkMode ? schemeDark : schemeLight,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      backgroundColor: Colors.transparent
    )
  );

  /* ThemeData getTheme(BuildContext context) => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle:MaterialStateProperty.resolveWith((states){
          return  GoogleFonts.nunito(
            color: Colors.yellow
          );
        })
      )
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF1F2F3),
      iconTheme: IconThemeData(
        color: Colors.black54
      )
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black87,
      )),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black87
        )
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black26
        )
      )
    ),
    textTheme: TextTheme(
      bodyMedium:  GoogleFonts.nunito(
        color: Colors.black87
      ),
      bodyLarge: GoogleFonts.nunito(
        color: Colors.black
      ),
      bodySmall: GoogleFonts.nunito(
        color: Colors.black
      ),
      displaySmall: GoogleFonts.nunito(
        color: Colors.black
      ),
      displayMedium: GoogleFonts.nunito(
        color: Colors.black87
      ),
      displayLarge: GoogleFonts.nunito(
        color: Colors.black87
      ),
      labelSmall: GoogleFonts.nunito(
        color: Colors.black87
      ),
      labelMedium: GoogleFonts.nunito(
        color: Colors.black87
      ),
      labelLarge: GoogleFonts.nunito(
        color: Colors.black87
      ),
      titleSmall: GoogleFonts.nunito(
        color: Colors.black87
      ),
      titleMedium: GoogleFonts.nunito(
        color: Colors.black87
      ),
      titleLarge: GoogleFonts.nunito(
        color: Colors.black87
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black54
    ),
    switchTheme: const SwitchThemeData(
      splashRadius: 40,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 157, 157, 157),
      onPrimary: Color(0xFF505050),
      secondary: Color.fromARGB(255, 95, 196, 251),
      onSecondary: Color(0xFFEAEAEA),
      error: Color(0xFFF32424),
      onError: Color(0xFFF32424),
      background: Color(0xFFF1F2F3),
      onBackground: Color(0xFFFFFFFF),
      surface: Color(0xFF8FFF8C),
      onSurface: Color(0xFF54B435),
    )
  );

  
  
  
  
  
  ThemeData getThemeDark() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF8FFF8C)
  ); */

}