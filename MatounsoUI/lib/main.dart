import 'package:flutter/material.dart';
import 'package:meditrackui/pages/loading_page.dart';
import 'package:meditrackui/pages/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meditrackui/pages/theme/theme_notifier_page.dart';
import 'package:provider/provider.dart';
import 'package:meditrackui/pages/theme/theme_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeNotifier(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'MediTrack',
      theme: ThemePage.lightTheme,
      darkTheme: ThemePage.darkTheme,
      themeMode: themeNotifier.themeMode,
      initialRoute: '/',
      debugShowMaterialGrid: false,

      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MyLoadingPage(),
        '/login': (context) => const MyLoginPage(),
      },
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [Locale('fr', 'FR')],
    );
  }
}
