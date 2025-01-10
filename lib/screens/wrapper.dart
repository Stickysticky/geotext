import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../models/customUser.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';
import 'package:geotext/providers/connectedUserProvider.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //return either Home r Authenticate widget

    final connectedUser = ref.watch(connectedUserNotifierProvider);
    //final connectedUser = Provider.of<CustomUser?>(context);

    if (connectedUser == null) {
      return Authenticate();
    } else {

      return Home();
    }
  }
}
