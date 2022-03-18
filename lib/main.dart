import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/auth/auth_screen.dart';
import 'package:stammtisch_manager/auth/german_label_overrides.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';
import 'package:stammtisch_manager/club_screens/events/new_event_screen.dart';
import 'package:stammtisch_manager/club_screens/dashboard/stammtisch_dashboard_screen.dart';
import 'package:stammtisch_manager/club_screens/root_screen/stammtisch_tabs_screen.dart';
import 'package:stammtisch_manager/firebase_options.dart';
import 'package:stammtisch_manager/provider/stammtisch_list_data.dart';
import 'package:stammtisch_manager/stammtisch_overview/main_tabs_screen.dart';
import 'package:stammtisch_manager/stammtisch_overview/stammtisch_overview_screen.dart';
import 'package:stammtisch_manager/stammtisch_overview/new_stammtisch_screen.dart';
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
          localizationsDelegates: [
            FlutterFireUILocalizations.withDefaultOverrides(
                const GermanLabelOverrides()),

            // Delegates below take care of built-in flutter widgets
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,

            // This delegate is required to provide the labels that are not overridden by LabelOverrides
            FlutterFireUILocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.red,
            textTheme: Theme.of(context).textTheme.copyWith(
                  headlineSmall: GoogleFonts.fredokaOne(
                      fontWeight: FontWeight.normal, fontSize: 22),
                  headlineMedium: GoogleFonts.fredokaOne(
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                  ),
                  headlineLarge:
                      GoogleFonts.fredokaOne(fontWeight: FontWeight.normal),
                  bodyMedium: GoogleFonts.fredokaOne(
                      fontWeight: FontWeight.normal, color: Colors.black54),
                  bodyLarge: GoogleFonts.fredokaOne(
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(180, 0, 0, 0),
                      fontSize: 18),
                ),
          ),
          home: appSnapshot.connectionState != ConnectionState.done
              ? const SplashScreen()
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (BuildContext context, AsyncSnapshot userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const AuthScreen();
                    }

                    return ChangeNotifierProvider.value(
                      value: StammtischListData(),
                      child: MainTabsScreen(),
                    );
                  },
                ),
          routes: {
            StammtischDashboardScreen.routeName: (context) =>
                StammtischDashboardScreen(),
            NewStammtischScreen.routeName: (context) =>
                const NewStammtischScreen(),
            StammtischTabsScreen.routeName: (context) =>
                const StammtischTabsScreen(),
            // StammtischOverviewScreen.routeName: (context) =>
            //     const StammtischOverviewScreen(),
            // NewEventScreen.routeName: (context) => NewEventScreen(
            //       eventData: EventModel.createNew(),
            // ),
          },
        );
      },
    );
  }
}
