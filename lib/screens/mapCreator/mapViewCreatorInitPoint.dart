import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/providers/currentMapProvider.dart';
import 'package:latlong2/latlong.dart';
import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';
import '../../services/utils.dart';

class MapViewCreatorInitPoint extends ConsumerStatefulWidget {
  const MapViewCreatorInitPoint({super.key});

  @override
  ConsumerState<MapViewCreatorInitPoint> createState() => _MapviewCreatorInitPointState();
}

class _MapviewCreatorInitPointState extends ConsumerState<MapViewCreatorInitPoint> {
  // Point initial de la carte : Paris
  LatLng? _center;
  List<Marker> markers = [];
  final MapController _mapController = MapController(); // Ajout du MapController

  void _recenterMap(GeoMap geoMap) {
    _mapController.moveAndRotate(
      LatLng(geoMap.initialCenter.latitude, geoMap.initialCenter.longitude),
      13, // Zoom initial
      0.0, // Rotation pour mettre le nord en haut
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isCreation = args?['isCreation'] ?? true;
    GeoMap geoMap = ref.watch(currentMapNotifierProvider)!;

    setState(() {

      if(_center == null){
        _center = geoMap.initialCenter;
      }


      if(markers.isEmpty){
        markers = [
          Marker(
            point: _center!,
            child: Icon(
              Icons.location_on,
              color: Colors.pink.shade400,
              size: 40,
            ),
          ),
        ];
      }

    });


    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: CustomAppBar(title: capitalizeFirstLetter(isCreation ? S.of(context).mapCreation : S.of(context).mapModification)),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: IconButton(
          onPressed: () {
            geoMap.initialCenter = _center!;
            Navigator.pushNamed(context, '/map_creator_point_creation', arguments: {'isCreation': isCreation});
          },
          icon: const Icon(Icons.arrow_right),
          style: IconButton.styleFrom(
            backgroundColor: Colors.pink.shade400,
          ),
          color: Colors.white,
          iconSize: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Texte d'indication en haut de la carte
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  S.of(context).infoMapInitPoint,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade400,
                  ),
                ),
              ),
              // La carte OpenStreetMap
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.70,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _center!,
                        onTap: (tapPosition, point) {
                          // Lorsque l'utilisateur clique sur la carte, ajoutez un marqueur
                          setState(() {
                            _center = point;
                            markers = [
                              Marker(
                                point: point,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.pink.shade400,
                                  size: 40,
                                ),
                              ),
                            ];
                          });
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
                        Scalebar()
                      ],
                    ),
                    Positioned(
                      bottom: 20, // Espace du bas
                      right: 5,  // Espace de la droite
                      child: ElevatedButton(
                        onPressed: () => _recenterMap(geoMap), // Appelle la fonction de recentrage
                        child: const Icon(Icons.my_location), // Icône de recentrage
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(), // Forme ronde comme le FloatingActionButton
                          backgroundColor: Colors.white, // Couleur d'arrière-plan (comme le backgroundColor de FloatingActionButton)
                          foregroundColor: Colors.brown.shade400, // Couleur du premier plan (comme le foregroundColor de FloatingActionButton)
                          padding: EdgeInsets.all(16), // Donne un padding pour augmenter la taille du bouton
                        ),
                      ),
                    ),

                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
