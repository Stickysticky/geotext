import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotext/commonWidgets/customAppBar.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/providers/connectedUserProvider.dart';

import '../../generated/l10n.dart';
import '../../providers/currentMapProvider.dart';
import 'mapCard.dart';

class MyMaps extends ConsumerWidget {
  const MyMaps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<GeoMap> myMaps = ref.read(connectedUserNotifierProvider)!.geoMapsOwner;
    List<GeoMap> mySharedMaps = ref.read(connectedUserNotifierProvider)!.geoMapsShared;

    List<GeoMap> combinedMaps = [...myMaps, ...mySharedMaps];
    combinedMaps.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: CustomAppBar(title: S.of(context).myMaps),
      floatingActionButton: IconButton(
        onPressed: () {
          ref.read(currentMapNotifierProvider.notifier).setGeoMap(null);
          Navigator.pushNamed(context, '/map_creation');
        },
        icon: Icon(Icons.plus_one),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.pink.shade400),
        ),
        color: Colors.white,
        iconSize: 40,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: combinedMaps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: MapCard(
                        map: combinedMaps[index],
                        isOwned: combinedMaps[index].owner.id == ref.watch(connectedUserNotifierProvider)!.id
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Le bouton flottant positionné en bas à droite
          /*Positioned(
            bottom: 16, // Distance du bas de l'écran
            right: 16,  // Distance du bord droit de l'écran
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/map_creation');
              },
              icon: Icon(Icons.plus_one),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.pink.shade400),
              ),
              color: Colors.white,
              iconSize: 40,
            ),
          ),*/
        ],
      ),
    );
  }
}
