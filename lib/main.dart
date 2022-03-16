import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/new_event_screen.dart';
import 'package:stammtisch_manager/club_screens/dashboard/stammtisch_dashboard_screen.dart';
import 'package:stammtisch_manager/club_screens/root_screen/stammtisch_tabs_screen.dart';
import 'package:stammtisch_manager/firebase_options.dart';
import 'package:stammtisch_manager/provider/stammtisch_list_data.dart';
import 'package:stammtisch_manager/stammtisch_overview/stammtisch_overview_screen.dart';
import 'package:stammtisch_manager/user_screens/new_stammtisch_screen.dart';
import 'package:stammtisch_manager/user_screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FutureBuilder(
      future: _initialization,
      builder: (context, appSnapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.red,
            textTheme: Theme.of(context).textTheme.copyWith(
                  headlineSmall: GoogleFonts.fredokaOne(
                      fontWeight: FontWeight.normal, fontSize: 22),
                  bodyMedium: GoogleFonts.fredokaOne(
                      fontWeight: FontWeight.normal, color: Colors.black54),
                ),
          ),
          home: appSnapshot.connectionState != ConnectionState.done
              ? const SplashScreen()
              : ChangeNotifierProvider.value(
                  value: StammtischListData(),
                  child: const StammtischOverviewScreen()),
          routes: {
            StammtischOverviewScreen.routeName: (context) =>
                const StammtischOverviewScreen(),
            StammtischDashboardScreen.routeName: (context) =>
                StammtischDashboardScreen(),
            NewStammtischScreen.routeName: (context) =>
                const NewStammtischScreen(),
            StammtischTabsScreen.routeName: (context) =>
                const StammtischTabsScreen(),
            NewEventScreen.routeName: (context) => const NewEventScreen(),
          },
        );
      },
    );
  }
}
