import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/providers/currentMapProvider.dart';

class MapCard extends ConsumerWidget {

  final GeoMap map;
  final bool isOwned;

  MapCard({required this.map, required this.isOwned});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return InkWell(
      onTap: () {
        ref.watch(currentMapNotifierProvider.notifier).setGeoMap(map);
        Navigator.pushNamed(context, '/map_view');
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 26.0, 16.0, 0),
        child:  Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Text(
                  map.title,
                  style: TextStyle(fontSize: 18.0),
                ),
                Spacer(),
                Icon(
                isOwned ? Icons.workspace_premium : Icons.group,
                color: Colors.brown.shade200,
                size: 40,
              )
              ],
            )
        ),

      ),
    );
  }
}
