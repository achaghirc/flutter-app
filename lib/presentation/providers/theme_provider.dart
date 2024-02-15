import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/config/theme/app_theme.dart';


final isDarkModePorvider = StateProvider((ref) => true);


// Un objeto de tipo AppTheme 

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode () {
    state = state.copyWith( isDarkMode: !state.isDarkMode);
  }

}