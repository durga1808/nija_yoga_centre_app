import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga_centre_app/presentation/splash.dart';

import 'package:yoga_centre_app/presentation/util/appcolor.dart';
import 'package:yoga_centre_app/presentation/util/pref.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga App',
      debugShowCheckedModeBanner: false,
      // theme: ThemeClass.lightTheme,
      // darkTheme: ThemeClass.darkTheme,
      // themeMode: ThemeMode.system,
      theme: ThemeData(
          fontFamily: 'Assistance',
          primarySwatch: CompanyColors.black,
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white //here you can give the text color
              ),
          cardTheme: const CardTheme(
              surfaceTintColor: Colors.white, color: Colors.white)),

      home: const SplashScreen(),
    );
  }
}

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const _PrimaryValue = 0xFF186F65;

  static const MaterialColor black = MaterialColor(
    _PrimaryValue,
    <int, Color>{
      50: Color(_PrimaryValue),
      100: Color(_PrimaryValue),
      200: Color(_PrimaryValue),
      300: Color(_PrimaryValue),
      400: Color(_PrimaryValue),
      500: Color(_PrimaryValue),
      600: Color(_PrimaryValue),
      700: Color(_PrimaryValue),
      800: Color(_PrimaryValue),
      900: Color(_PrimaryValue),
    },
  );
}
