import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/providers/currentMapProvider.dart';
import 'package:latlong2/latlong.dart';
import '../../commonWidgets/customAppBar.dart';
import '../../generated/l10n.dart';
import '../../services/utils.dart';

class MapViewCreatorPointCreation extends ConsumerStatefulWidget {
  const MapViewCreatorPointCreation({super.key});

  @override
  ConsumerState<MapViewCreatorPointCreation> createState() =>
      _MapviewCreatorPointCreationState();
}

class _MapviewCreatorPointCreationState
    extends ConsumerState<MapViewCreatorPointCreation> {
  List<Marker> geoMapPoints = [];
  List<Marker> popupMarkers = [];
  late final MapController _mapController;
  LatLng? selectedPoint;

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Column(
          children: [
            // Texte d'indication en haut de la carte
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Veuillez ajouter au moins un point', // S.of(context).infoMapPointCreation,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade400,
                ),
              ),
            ),
            // La carte OpenStreetMap
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: geoMap.initialCenter,
                  onTap: (tapPosition, point) {
                    Marker marker = Marker(
                      point: point,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.pink.shade400,
                        size: 40,
                      ),
                    );

                    setState(() {
                      geoMapPoints.add(marker);
                      _mapController.move(point, 13);
                      popupMarkers.add(marker);
                    });

                    print(popupMarkers);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: geoMapPoints,
                  ),
                  PopupMarkerLayer(
                      options: PopupMarkerLayerOptions(
                          markers: popupMarkers,
                        /*popupDisplayOptions: PopupDisplayOptions(
                          builder: (BuildContext context, Marker marker) =>
                              ExamplePopup(marker),
                        ),*/
                      )
                  )

                ],
              ),
            ),
            Padding(
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
            ),
          ],
        ),
      ),
    );
  }
}
