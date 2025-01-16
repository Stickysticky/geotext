import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geotext/commonWidgets/customAppBar.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/providers/currentMapProvider.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  @override
  Widget build(BuildContext context) {
    final GeoMap geoMap = ref.read(currentMapNotifierProvider)!;

    final markers = geoMap.geoMapPoints.map(
        (point) => Marker(
            point: LatLng(point.geoPoint.latitude, point.geoPoint.longitude),
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            )
        )
    ).toList();

    return Scaffold(
      appBar: CustomAppBar(geoMap.title),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            geoMap.initialCenter.latitude,
            geoMap.initialCenter.longitude,
          ),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }
}
