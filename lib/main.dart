import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/recipe_provider.dart';
import 'utils/app_themes.dart';
import 'views/splash/splash_screen.dart';
import 'views/home/home_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'views/recipe/send_recipe_screen.dart';
import 'views/settings/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const CookEasyApp(),
    ),
  );
}

class CookEasyApp extends StatelessWidget {
  const CookEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'CookEasy',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          home: SplashScreen(),
          routes: {
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/home': (context) => HomeScreen(),
            '/send_recipe': (context) => const SendRecipeScreen(),
            '/settings': (context) => SettingsScreen(),
          },
        );
      },
    );
  }
}