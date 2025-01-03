import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geotext/screens/myAccount/accountCard.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/customUser.dart';
import '../../services/auth.dart';
import '../../services/utils.dart';

class MyAccount extends StatelessWidget {
  MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    CustomUser user = Provider.of<CustomUser>(context);

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
      body: Card(
        margin: EdgeInsets.fromLTRB(6.0, 16.0, 6.0, 0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            AccountCard('Email', user.email, true),
            Divider(
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            AccountCard('Nom d\'utilisateur', user.userName, true)
          ],
        ),
      ),
    );
  }
}
