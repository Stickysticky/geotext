import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customUser.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //return either Home r Authenticate widget
    
    //final connectedUser = Provider.of<CustomUser?>(context);
    final connectedUser = Provider.of<CustomUser?>(context);

    if (connectedUser == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
