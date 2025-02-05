// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(mapTitle) =>
      "You are about to delete the map ${mapTitle} and all its related data. Do you want to continue?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("geotext"),
        "cancel": MessageLookupByLibrary.simpleMessage("cancel"),
        "close": MessageLookupByLibrary.simpleMessage("close"),
        "color": MessageLookupByLibrary.simpleMessage("color"),
        "delete": MessageLookupByLibrary.simpleMessage("delete"),
        "deleteMap": MessageLookupByLibrary.simpleMessage("removing the map"),
        "deleteMapConfirmation": m0,
        "deletedMap": MessageLookupByLibrary.simpleMessage("map deleted"),
        "email": MessageLookupByLibrary.simpleMessage("email"),
        "enterEmail": MessageLookupByLibrary.simpleMessage("enter an email"),
        "enterPassword": MessageLookupByLibrary.simpleMessage(
            "enter a password 6+ char long"),
        "errorTitle":
            MessageLookupByLibrary.simpleMessage("an error has occurred"),
        "infoMapInitPoint": MessageLookupByLibrary.simpleMessage(
            "Click on the map to select the center of your map."),
        "invalidEmail":
            MessageLookupByLibrary.simpleMessage("please enter a valid email"),
        "isPrivate": MessageLookupByLibrary.simpleMessage("put in private"),
        "logout": MessageLookupByLibrary.simpleMessage("logout"),
        "mapCreation": MessageLookupByLibrary.simpleMessage("map creation"),
        "mapModification": MessageLookupByLibrary.simpleMessage("edit map"),
        "mapSaved": MessageLookupByLibrary.simpleMessage("map sauvegardé !"),
        "message": MessageLookupByLibrary.simpleMessage("message"),
        "myAccount": MessageLookupByLibrary.simpleMessage("my account"),
        "myFriends": MessageLookupByLibrary.simpleMessage("my friends"),
        "myMaps": MessageLookupByLibrary.simpleMessage("my maps"),
        "notifications": MessageLookupByLibrary.simpleMessage("notifications"),
        "pleaseAddPoint": MessageLookupByLibrary.simpleMessage(
            "Please add at least one point"),
        "pointSaved": MessageLookupByLibrary.simpleMessage("point saved !"),
        "radiusInfo": MessageLookupByLibrary.simpleMessage("rayon (m)"),
        "radiusRequired":
            MessageLookupByLibrary.simpleMessage("the radius is required"),
        "radiusValidation":
            MessageLookupByLibrary.simpleMessage("enter a valid radius (> 0)"),
        "register": MessageLookupByLibrary.simpleMessage("register"),
        "registerErrorMailUsed": MessageLookupByLibrary.simpleMessage(
            "the email address is already in use"),
        "registerInvalidEmail": MessageLookupByLibrary.simpleMessage(
            "your email adress is invalid."),
        "registerTitle":
            MessageLookupByLibrary.simpleMessage("register to Geotext"),
        "registerWeakPassword": MessageLookupByLibrary.simpleMessage(
            "your password is to weak. Please use a strong password."),
        "save": MessageLookupByLibrary.simpleMessage("save"),
        "searchMap": MessageLookupByLibrary.simpleMessage("search for maps"),
        "selectAColor": MessageLookupByLibrary.simpleMessage("select a color"),
        "signIn": MessageLookupByLibrary.simpleMessage("sign in"),
        "signInError": MessageLookupByLibrary.simpleMessage(
            "an error occurred while connecting. Please check your email and password."),
        "signInTitle":
            MessageLookupByLibrary.simpleMessage("sign in to Geotext"),
        "title": MessageLookupByLibrary.simpleMessage("title"),
        "titleRequired":
            MessageLookupByLibrary.simpleMessage("The title is required"),
        "unknownErrorRegister": MessageLookupByLibrary.simpleMessage(
            "an error occured while registering. Please check your informations and try later"),
        "userDisplayName": MessageLookupByLibrary.simpleMessage("display name"),
        "userName": MessageLookupByLibrary.simpleMessage("user name"),
        "validate": MessageLookupByLibrary.simpleMessage("validate")
      };
}
