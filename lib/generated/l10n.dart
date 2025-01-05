// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `register to Geotext`
  String get registerTitle {
    return Intl.message(
      'register to Geotext',
      name: 'registerTitle',
      desc: '',
      args: [],
    );
  }

  /// `sign in to Geotext`
  String get signInTitle {
    return Intl.message(
      'sign in to Geotext',
      name: 'signInTitle',
      desc: '',
      args: [],
    );
  }

  /// `register`
  String get register {
    return Intl.message(
      'register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `sign in`
  String get signIn {
    return Intl.message(
      'sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `enter an email`
  String get enterEmail {
    return Intl.message(
      'enter an email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `enter a password 6+ char long`
  String get enterPassword {
    return Intl.message(
      'enter a password 6+ char long',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `an error has occurred`
  String get errorTitle {
    return Intl.message(
      'an error has occurred',
      name: 'errorTitle',
      desc: '',
      args: [],
    );
  }

  /// `an error occurred while connecting. Please check your email and password.`
  String get signInError {
    return Intl.message(
      'an error occurred while connecting. Please check your email and password.',
      name: 'signInError',
      desc: '',
      args: [],
    );
  }

  /// `the email address is already in use`
  String get registerErrorMailUsed {
    return Intl.message(
      'the email address is already in use',
      name: 'registerErrorMailUsed',
      desc: '',
      args: [],
    );
  }

  /// `an error occured while registering. Please check your informations and try later`
  String get unknownErrorRegister {
    return Intl.message(
      'an error occured while registering. Please check your informations and try later',
      name: 'unknownErrorRegister',
      desc: '',
      args: [],
    );
  }

  /// `your password is to weak. Please use a strong password.`
  String get registerWeakPassword {
    return Intl.message(
      'your password is to weak. Please use a strong password.',
      name: 'registerWeakPassword',
      desc: '',
      args: [],
    );
  }

  /// `your email adress is invalid.`
  String get registerInvalidEmail {
    return Intl.message(
      'your email adress is invalid.',
      name: 'registerInvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `geotext`
  String get appTitle {
    return Intl.message(
      'geotext',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `logout`
  String get logout {
    return Intl.message(
      'logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `my account`
  String get myAccount {
    return Intl.message(
      'my account',
      name: 'myAccount',
      desc: '',
      args: [],
    );
  }

  /// `my maps`
  String get myMaps {
    return Intl.message(
      'my maps',
      name: 'myMaps',
      desc: '',
      args: [],
    );
  }

  /// `user name`
  String get userName {
    return Intl.message(
      'user name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `display name`
  String get userDisplayName {
    return Intl.message(
      'display name',
      name: 'userDisplayName',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
