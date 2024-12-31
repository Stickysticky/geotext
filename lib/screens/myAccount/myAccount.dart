import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/customUser.dart';
import '../../services/auth.dart';
import '../../services/utils.dart';

class MyAccount extends StatelessWidget {
  MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    print(Provider.of<User?>(context));
    print ('ici');
    print(user);

    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        centerTitle: true,
          title: Text(
            capitalizeFirstLetter(S.of(context).myAccount),
            style: TextStyle(
              color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.brown.shade400,
          elevation: 0.0,
      ),
    );
  }
}
