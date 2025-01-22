import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geotext/commonWidgets/customAppBar.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/providers/currentMapProvider.dart';

import '../../models/geoMapPoint.dart';
import '../../providers/connectedUserProvider.dart';
import '../mapsWidget/popuUpMarkerGeotext.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  List<Marker> markers = [];
  bool isLoading = true;
  final PopupController _popupController = PopupController();

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final GeoMap geoMap = ref.read(currentMapNotifierProvider)!;

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      markers = geoMap.geoMapPoints
          .map(
            (point) => Marker(
          point: LatLng(point.geoPoint.latitude, point.geoPoint.longitude),
          child: Icon(
            Icons.location_on,
            color: point.color,
            size: 40,
          ),
        ),
      )
          .toList();

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GeoMap geoMap = ref.read(currentMapNotifierProvider)!;
    _popupController.showPopupsAlsoFor(_generateMarkersFromGeoMapPoints(geoMap));

    return Scaffold(
      appBar: CustomAppBar(geoMap.title),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Afficher le loader
      )
          : FlutterMap(
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
            CircleLayer(
              circles: geoMap.geoMapPoints.map((geoMapPoint) {
                return CircleMarker(
                  point: LatLng(
                    geoMapPoint.geoPoint.latitude,
                    geoMapPoint.geoPoint.longitude,
                  ),
                  color: geoMapPoint.color.withOpacity(0.3),
                  borderStrokeWidth: 1,
                  borderColor: geoMapPoint.color,
                  useRadiusInMeter: true,
                  radius: geoMapPoint.radius.toDouble(),
                );
              }).toList(),
            ),
            PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
                  markers: _generateMarkersFromGeoMapPoints(geoMap),
                  popupController: _popupController,
                  popupDisplayOptions: PopupDisplayOptions(
                    //builder: (BuildContext context, Marker marker) =>
                    //  PopUpMarkerGeotext(marker),
                    builder: (BuildContext context, Marker marker) {
                      // Chercher le GeoMapPoint correspondant au marker
                      final geoMapPoint = geoMap.geoMapPoints.firstWhere(
                            (point) => LatLng(point.geoPoint.latitude, point.geoPoint.longitude) == marker.point,
                        orElse: () => GeoMapPoint( // Provide a default point or empty point
                          title: 'Unknown',
                          message: 'No message available',
                          geoMap: geoMap, // Pass the relevant GeoMap if needed
                          geoPoint: GeoPoint(0.0, 0.0), // Default GeoPoint
                          creator: ref.read(connectedUserNotifierProvider)!, // Set creator if needed
                        ), // Gérer le cas où aucun GeoMapPoint n'est trouvé
                      );
                      if (geoMapPoint != null) {
                        return PopUpMarkerGeotext(marker, geoMapPoint);
                      } else {
                        return Container(); // Ou une popup par défaut
                      }
                    },
                  ),
                )
            ),
          ],
      ),
    );
  }

  List<Marker> _generateMarkersFromGeoMapPoints(GeoMap geoMap) {
    // Convertit chaque GeoMapPoint en Marker
    return geoMap.geoMapPoints.map((point) {
      return Marker(
        point: LatLng(point.geoPoint.latitude, point.geoPoint.longitude),
        child: Icon(
          Icons.location_on,
          color: point.color,
          size: 40,
        ),
      );
    }).toList();
  }

}
