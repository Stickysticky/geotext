import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotext/models/geoMapPoint.dart';

class PopUpMarkerGeotext extends StatelessWidget {
  final Marker marker;
  final GeoMapPoint geoMapPoint;

  const PopUpMarkerGeotext(this.marker, this.geoMapPoint, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              geoMapPoint.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(geoMapPoint.message ?? ''),
          ],
        ),
      ),
    );
  }
}