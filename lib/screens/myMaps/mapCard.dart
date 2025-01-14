import 'package:flutter/material.dart';

class MapCard extends StatelessWidget {

  final String title;
  final bool isOwned;

  MapCard({required this.title, required this.isOwned});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.pushNamed(context, route);
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 26.0, 16.0, 0),
        child:  Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0),
                ),
                Spacer(),
                /*Icon(
                iconData,
                color: Colors.brown.shade200,
                size: 40,
              )*/
              ],
            )
        ),

      ),
    );
  }
}
