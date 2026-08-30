import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'booking_page.dart';
import 'splash_page.dart';
import 'payments_page.dart';
import 'history_page.dart';
import 'driver_page.dart';
import 'settings_page.dart';
import 'pages/maps_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'consent_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moto-Taxi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: const StadiumBorder(),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: const StadiumBorder(),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F8E9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorShape: StadiumBorder(),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/consent': (context) => const ConsentPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/booking': (context) => const BookingPage(),
        '/payments': (context) => const PaymentsPage(),
        '/history': (context) => const HistoryPage(),
        '/driver': (context) => const DriverPage(),
        '/settings': (context) => const SettingsPage(),
        '/maps': (context) => const MapsPage(),
      },
    );
  }
}


