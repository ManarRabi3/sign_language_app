import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'features/home/presentation/pages/home page.dart';
import 'features/sign_to_text/presentation/pages/sign_to_text_page.dart';
import 'features/text_to_sign/presentation/pages/text_to_sign_page.dart';
import 'features/dictionary/presentation/pages/dictionary_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set system UI overlay styleb
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  const SignLanguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // Localization
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Routes
      //....
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/sign-to-text': (context) => const SignToTextPage(),
        '/text-to-sign': (context) => const TextToSignPage(),
        '/dictionary': (context) => const DictionaryPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
