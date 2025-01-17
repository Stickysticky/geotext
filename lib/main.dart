import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geotext/screens/home/home.dart';
import 'package:geotext/screens/mapCreator/mapViewCreatorInitPoint.dart';
import 'package:geotext/screens/mapCreator/mapViewCreatorPointCreation.dart';
import 'package:geotext/screens/mapCreator/mapViewCreatorTextData.dart';
import 'package:geotext/screens/myAccount/myAccount.dart';
import 'package:geotext/screens/myMaps/mapView.dart';
import 'package:geotext/screens/myMaps/myMaps.dart';
import 'package:geotext/screens/wrapper.dart';
import 'package:geotext/services/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importez Riverpod

import 'models/customUser.dart';
import 'generated/l10n.dart';

// Point d'entrée de l'application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp())); // Enveloppez l'application avec ProviderScope
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('fr'), // Définit la langue par défaut sur français
      supportedLocales: const [
        Locale('fr', ''), // Français (par défaut)
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate, // Ajoute votre délégué généré pour les traductions
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Résolution de la langue en fonction de la configuration de l'utilisateur
        if (locale == null) {
          return const Locale('fr');
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return const Locale('fr');
      },
      home: const Wrapper(), // Point d'entrée de l'application
      routes: {
        '/map_view': (context) => MapView(),
        '/map_creation': (context) => MapViewCreatorTextData(),
        '/map_creator_init_point': (context) => MapViewCreatorInitPoint(),
        '/map_creator_point_creation': (context) => MapViewCreatorPointCreation(),
        '/my_maps': (context) => MyMaps(),
        '/my_account': (context) => MyAccount(),
        '/home': (context) => Home(),
      },
    );
  }

}
