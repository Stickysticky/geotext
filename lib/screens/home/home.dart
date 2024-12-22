import 'package:flutter/material.dart';
import '../../services/auth.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        title: Text('Brew Crew'),
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
                  Text('logout'),
                ],
              ),
            )
          ]
      )
    );
  }
}
