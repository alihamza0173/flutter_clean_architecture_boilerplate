import 'package:material_ui/material_ui.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      appBarTheme: const AppBarTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(textStyle: AppTextStyles.button),
      ),
      inputDecorationTheme: const InputDecorationTheme(),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: .dark,
      ),
      appBarTheme: const AppBarTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(textStyle: AppTextStyles.button),
      ),
      inputDecorationTheme: const InputDecorationTheme(),
    );
  }
}
