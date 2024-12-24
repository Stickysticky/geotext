import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geotext/screens/wrapper.dart';
import 'package:geotext/services/auth.dart';
import 'package:provider/provider.dart';

import 'models/customUser.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
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
      ),
    );
  }
}
