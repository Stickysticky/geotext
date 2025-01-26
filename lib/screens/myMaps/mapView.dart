import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotext/models/customUser.dart';
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
  GeoMapPoint? _selectedGeoMapPoint;
  final MapController _mapController = MapController(); // Ajout du MapController

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
              width: 40, // Taille du marqueur
              height: 40,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if(_selectedGeoMapPoint == null){
                  _selectedGeoMapPoint = point;
                  _popupController.showPopupsAlsoFor(_generateMarkerFromGeoMapPoint(_selectedGeoMapPoint!));
                } else {
                  _selectedGeoMapPoint = null;
                  _popupController.hideAllPopups();
                }
              });


            },
            child: Icon(
              Icons.location_on,
              color: point.color,
              size: 40,
            ),
          ),
        ),
      )
          .toList();

      isLoading = false;
    });
  }

  void _toModificationMap (GeoMap map) {
    Navigator.pushNamed(
      context,
      '/map_creation',
      arguments: {
        'isCreation': false,
        'geoMap': map
      }
    );

  }

  void _recenterMap(GeoMap geoMap) {
    // Fonction pour recentrer la carte
    _mapController.moveAndRotate(
      LatLng(geoMap.initialCenter.latitude, geoMap.initialCenter.longitude),
      13, // Zoom initial
      0.0, // Rotation pour mettre le nord en haut
    );
  }


  @override
  Widget build(BuildContext context) {
    //final GeoMap geoMap = ref.read(currentMapNotifierProvider)!;
    final geoMap = ModalRoute.of(context)?.settings.arguments as GeoMap;
    CustomUser user = ref.read(connectedUserNotifierProvider)!;

    return Scaffold(
      appBar: CustomAppBar(
          title: geoMap.title,
          icon: user.id == geoMap.owner.id ?
            const Icon(
                Icons.edit,
                color: Colors.white
            ) : null
          ,
          pressedIcon: user.id == geoMap.owner.id
              ? () => _toModificationMap(geoMap)
              : null
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Afficher le loader
      )
          : FlutterMap(
        mapController: _mapController,
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
          // Utiliser une seule source pour les marqueurs
          MarkerLayer(
            markers: markers,
          ),
          if (_selectedGeoMapPoint != null) // Affiche le cercle uniquement si un point est sélectionné
            CircleLayer(
              circles: [
                CircleMarker(
                  point: LatLng(
                    _selectedGeoMapPoint!.geoPoint.latitude,
                    _selectedGeoMapPoint!.geoPoint.longitude,
                  ),
                  color: _selectedGeoMapPoint!.color.withOpacity(0.3),
                  borderStrokeWidth: 1,
                  borderColor: _selectedGeoMapPoint!.color,
                  useRadiusInMeter: true,
                  radius: _selectedGeoMapPoint!.radius.toDouble(),
                ),
              ],
            ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markers: markers, // Réutilise la même liste
              popupController: _popupController,
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) {
                  final geoMapPoint = geoMap.geoMapPoints.firstWhere(
                        (point) =>
                    LatLng(point.geoPoint.latitude,
                        point.geoPoint.longitude) ==
                        marker.point,
                    orElse: () => GeoMapPoint(
                      title: 'Unknown',
                      message: 'No message available',
                      geoMap: geoMap,
                      geoPoint: GeoPoint(0.0, 0.0),
                      creator: ref
                          .read(connectedUserNotifierProvider)!, // Développez si nécessaire
                    ),
                  );
                  if (geoMapPoint != null) {
                    return PopUpMarkerGeotext(marker, geoMapPoint);
                  } else {
                    return Container(); // Ou une popup par défaut
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _recenterMap(geoMap), // Appelle la fonction de recentrage
        child: const Icon(Icons.my_location), // Icône de recentrage
        foregroundColor: Colors.brown.shade400,
        backgroundColor: Colors.white,
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

  List<Marker> _generateMarkerFromGeoMapPoint(GeoMapPoint point) {
    return [
      Marker(
        point: LatLng(point.geoPoint.latitude, point.geoPoint.longitude),
        child: Icon(
          Icons.location_on,
          color: point.color,
          size: 40,
        ),
      )
    ];
  }

}
