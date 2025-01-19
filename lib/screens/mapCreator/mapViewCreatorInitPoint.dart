import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
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
  LatLng _center = LatLng(48.8566, 2.3522); // Coordonnées de Paris
  List<Marker> markers = [
    Marker(
      point: LatLng(48.8566, 2.3522),
      child: Icon(
        Icons.location_on,
        color: Colors.pink.shade400,
        size: 40,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: CustomAppBar(capitalizeFirstLetter(S.of(context).mapCreation)),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: IconButton(
          onPressed: () {
            //ref.watch(currentMapNotifierProvider)!.initialCenter = _center;
            ref.watch(currentMapNotifierProvider.notifier).updateCenterMap(_center);
            Navigator.pushNamed(context, '/map_creator_point_creation');
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
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              child: Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _center,
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
                  ],
                ),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                onPressed: () {
                    //ref.watch(currentMapNotifierProvider)!.initialCenter = _center;
                  ref.watch(currentMapNotifierProvider.notifier).updateCenterMap(_center);
                  Navigator.pushNamed(context, '/map_creator_point_creation');
                },
                icon: const Icon(Icons.arrow_right),
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
    );
  }
}
