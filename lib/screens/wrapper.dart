import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customUser.dart';
import '../providers/authServiceProvider.dart';
import '../services/auth.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';
import 'package:geotext/providers/connectedUserProvider.dart';

class Wrapper extends ConsumerWidget {
  /*String? _email = null;
  String? _password = null;

  Wrapper({String? email, String? password})
      : _email = email,
        _password = password;*/

  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //return either Home r Authenticate widget

    final connectedUser = ref.watch(connectedUserNotifierProvider);
    //final connectedUser = Provider.of<CustomUser?>(context);

    if (connectedUser == null) {
      _signInWithMemoryInfo(ref);

      if(ref.watch(connectedUserNotifierProvider) != null){
        return Home();
      }

      return Authenticate();
    } else {
      return Home();
    }
  }

  Future<void> _signInWithMemoryInfo(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if(email != null && password != null){
      final AuthService auth = ref.read(authServiceProvider);
      auth.signIn(email, password);
    }
  }




}
