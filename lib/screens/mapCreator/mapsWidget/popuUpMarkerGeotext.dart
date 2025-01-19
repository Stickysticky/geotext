import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class PopUpMarkerGeotext extends StatelessWidget {
  final Marker marker;

  const PopUpMarkerGeotext(this.marker, {super.key});

  @override
  Widget build(BuildContext context) {
    print('ici');
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Marker Info',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('Latitude: ${marker.point.latitude.toStringAsFixed(5)}'),
            Text('Longitude: ${marker.point.longitude.toStringAsFixed(5)}'),
          ],
        ),
      ),
    );
  }
}