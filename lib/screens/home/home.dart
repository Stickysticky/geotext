import 'package:flutter/material.dart';
import 'package:geotext/screens/home/menuCard.dart';
import '../../generated/l10n.dart';
import '../../services/auth.dart';
import '../../services/utils.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        title: Text(
            capitalizeFirstLetter(S.of(context).appTitle),
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.brown.shade400,
        elevation: 0.0,
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.black),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 5),
                  Text(capitalizeFirstLetter(S.of(context).logout)),
                ],
              ),
            )
          ]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
       children: <Widget>[
          MenuCard(
              text: capitalizeFirstLetter(S.of(context).myAccount),
              iconData: Icons.account_circle
          ),
         MenuCard(
             text: capitalizeFirstLetter(S.of(context).myMaps),
             iconData: Icons.map
         ),
       ],
      )
    );
  }
}
