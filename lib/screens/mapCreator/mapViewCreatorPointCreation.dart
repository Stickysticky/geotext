import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/models/geoMapPoint.dart';
import 'package:geotext/providers/connectedUserProvider.dart';
import 'package:geotext/providers/currentGeoMapPointProvider.dart';
import 'package:geotext/providers/currentMapProvider.dart';
import 'package:geotext/screens/mapCreator/geoMapPointCreator.dart';
import 'package:latlong2/latlong.dart';
import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';
import '../../services/utils.dart';
import 'mapsWidget/popuUpMarkerGeotext.dart';

class MapViewCreatorPointCreation extends ConsumerStatefulWidget {
  const MapViewCreatorPointCreation({super.key});

  @override
  ConsumerState<MapViewCreatorPointCreation> createState() =>
      _MapviewCreatorPointCreationState();
}

class _MapviewCreatorPointCreationState
    extends ConsumerState<MapViewCreatorPointCreation> {
  List<Marker> geoMapPoints = [];
  List<Marker> markers = [];
  List<Marker> popupMarkers = [];
  late final MapController _mapController;
  LatLng? selectedPoint;
  final PopupController _popupController = PopupController();
  double mapHeightFraction = 1.0;
  bool allPointMapVisibility = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    GeoMap geoMap = ref.read(currentMapNotifierProvider)!;

    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: CustomAppBar(capitalizeFirstLetter(S.of(context).mapCreation)),
      floatingActionButton: geoMapPoints.isNotEmpty || ref.read(currentGeoMapPointNotifierProvider) != null ?
      AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: IconButton(
            onPressed: () {
              // Ajoutez votre logique pour valider ou enregistrer les données
            },
            icon: const Icon(Icons.check),
            style: IconButton.styleFrom(
              backgroundColor: Colors.pink.shade400,
            ),
            color: Colors.white,
            iconSize: 40,
          ),
        ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Column(
            children: [
              // Texte d'indication en haut de la carte
              Visibility(
                visible: allPointMapVisibility,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    child: Text(
                      S.of(context).pleaseAddPoint,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade400,
                      ),
                    ),
                  )
              ),
        
              // La carte OpenStreetMap
              AnimatedContainer(
                padding: EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                duration: const Duration(milliseconds: 300), // Animation fluide
                height: MediaQuery.of(context).size.height * mapHeightFraction,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: geoMap.initialCenter,
                    onTap: (tapPosition, point) {
                      //_popupController.hideAllPopups();
                      ref.read(currentGeoMapPointNotifierProvider.notifier).setGeoMapPoint(
                        GeoMapPoint(
                            title: '',
                            geoMap: geoMap,
                            geoPoint: GeoPoint(point.latitude, point.longitude),
                            creator: ref.read(connectedUserNotifierProvider)!
                        )
                      );
                      Marker marker = Marker(
                        point: point,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.pink.shade400,
                          size: 40,
                        ),
                      );
        
                      setState(() {
                        mapHeightFraction = 0.3;
                        _mapController.move(point, 20);
                        allPointMapVisibility = false;
                        markers = [marker];
        
        
                        geoMapPoints.add(marker);
                        popupMarkers = [marker];
        
                      });
                      //_popupController.showPopupsAlsoFor(popupMarkers);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: markers,
                    ),
                    PopupMarkerLayer(
                        options: PopupMarkerLayerOptions(
                          markers: popupMarkers,
                          popupController: _popupController,
                          popupDisplayOptions: PopupDisplayOptions(
                            builder: (BuildContext context, Marker marker) =>
                                PopUpMarkerGeotext(marker),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                  child: GeoMapPointCreator(),
                ),
                visible: !allPointMapVisibility,
        
              )
              /*Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  onPressed: () {
                    // Ajoutez votre logique pour valider ou enregistrer les données
                  },
                  icon: const Icon(Icons.check),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                  ),
                  color: Colors.white,
                  iconSize: 40,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
