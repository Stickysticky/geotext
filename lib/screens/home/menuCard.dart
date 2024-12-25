import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {

  final String text;
  final IconData iconData;

  MenuCard({required this.text, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 26.0, 16.0, 0),
      child:  Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(fontSize: 18.0),
            ),
            Spacer(),
            Icon(
              iconData,
              color: Colors.brown.shade200,
              size: 40,
            )
          ],
        )
      ),
    );
  }
}
