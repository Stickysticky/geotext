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
import '../mapsWidget/popuUpMarkerGeotext.dart';

class MapViewCreatorPointCreation extends ConsumerStatefulWidget {
  const MapViewCreatorPointCreation({super.key});

  @override
  ConsumerState<MapViewCreatorPointCreation> createState() =>
      _MapviewCreatorPointCreationState();
}

class _MapviewCreatorPointCreationState
    extends ConsumerState<MapViewCreatorPointCreation> {
  late final MapController _mapController;
  final PopupController _popupController = PopupController();
  double mapHeightFraction = 1.0;
  bool allPointMapVisibility = true;
  late GeoMap geoMap;
  GeoMapPoint? currentPoint;
  Marker? currentMarker;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _updateVisibility(bool isVisible) {
    setState(() {
      allPointMapVisibility = isVisible;
      mapHeightFraction = isVisible ? 1 : 0.3;
      _mapController.move(LatLng(currentPoint!.geoPoint.latitude, currentPoint!.geoPoint.longitude), 13.0);
    });

    _popupController.showPopupsAlsoFor(_generateMarkersFromGeoMapPoints(geoMap));
  }

  void _savePointsAndMap(){
    geoMap.saveToFirestore();

    for(GeoMapPoint point in geoMap.geoMapPoints){
      point.saveGeoMapPointToFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      geoMap = ref.watch(currentMapNotifierProvider)!;
      _popupController.showPopupsAlsoFor(_generateMarkersFromGeoMapPoints(geoMap));
    });


    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar:CustomAppBar(title: capitalizeFirstLetter(S.of(context).mapCreation)),
      floatingActionButton: geoMap.geoMapPoints.isNotEmpty  && allPointMapVisibility ?
      AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: IconButton(
            onPressed: () {
              _savePointsAndMap();
              ref.read(connectedUserNotifierProvider.notifier).addOwnedMap(geoMap);
              ref.read(currentMapNotifierProvider.notifier).setGeoMap(null);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(capitalizeFirstLetter(S.of(context).mapSaved))),
              );
              Navigator.pushNamed(context, '/my_maps');
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
              geoMap.geoMapPoints.isEmpty ?
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
                ) : Container(),
        
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
                      setState(() {
                        currentMarker = Marker(
                          point: point,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.pink.shade400,
                            size: 40,
                          ),
                        );

                        currentPoint = GeoMapPoint(
                            title: '',
                            geoMap: geoMap,
                            geoPoint: GeoPoint(point.latitude, point.longitude),
                            creator: ref.read(connectedUserNotifierProvider)!
                        );
                      });
                      ref.read(currentGeoMapPointNotifierProvider.notifier).setGeoMapPoint(
                        currentPoint
                      );


                      setState(() {
                        mapHeightFraction = 0.3;
                        _mapController.move(point, 20);
                        allPointMapVisibility = false;
                      });


                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        if (currentMarker != null) currentMarker!,
                        ..._generateMarkersFromGeoMapPoints(geoMap),
                      ],
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
                  ],
                ),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                  child: GeoMapPointCreator(point: currentPoint,
                      isVisible: allPointMapVisibility,
                      onVisibilityChanged: _updateVisibility),
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
