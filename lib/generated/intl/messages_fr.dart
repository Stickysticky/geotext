// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("geotext"),
        "email": MessageLookupByLibrary.simpleMessage("email"),
        "enterEmail": MessageLookupByLibrary.simpleMessage("entrez un email"),
        "enterPassword": MessageLookupByLibrary.simpleMessage(
            "entrez un mot de passe de plus de 6 caractères"),
        "errorTitle":
            MessageLookupByLibrary.simpleMessage("une erreur a eu lieu"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "veuillez entrer un email valide"),
        "logout": MessageLookupByLibrary.simpleMessage("déconnexion"),
        "myAccount": MessageLookupByLibrary.simpleMessage("mon compte"),
        "myMaps": MessageLookupByLibrary.simpleMessage("mes cartes"),
        "register": MessageLookupByLibrary.simpleMessage("inscription"),
        "registerErrorMailUsed": MessageLookupByLibrary.simpleMessage(
            "l\'adresse mail est déjà utilisée"),
        "registerInvalidEmail": MessageLookupByLibrary.simpleMessage(
            "l\'adresse mail n\'est pas valide."),
        "registerTitle":
            MessageLookupByLibrary.simpleMessage("s\'inscrire à Geotext"),
        "registerWeakPassword": MessageLookupByLibrary.simpleMessage(
            "votre mot de passe n\'est pas assez sécurisé. Veuillez entrer un autre mot de passe."),
        "signIn": MessageLookupByLibrary.simpleMessage("connexion"),
        "signInError": MessageLookupByLibrary.simpleMessage(
            "une erreur a eu lieu lors de la connexion. Veuillez vérifier votre mail et votre mot de passe."),
        "signInTitle":
            MessageLookupByLibrary.simpleMessage("connexion à Geotext"),
        "unknownErrorRegister": MessageLookupByLibrary.simpleMessage(
            "une erreur a eu lieu lors de l\'inscription. Veuillez vérifier les informations et réessayer plus tard."),
        "userDisplayName":
            MessageLookupByLibrary.simpleMessage("nom d\'affichage"),
        "userName": MessageLookupByLibrary.simpleMessage("nom d\'utilisateur")
      };
}
