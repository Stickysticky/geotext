import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotext/commonWidgets/customAppBar.dart';

import '../../generated/l10n.dart';

class MyMaps extends ConsumerWidget {
  const MyMaps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: CustomAppBar(S.of(context).myMaps),
      body: Stack( // Utilisez Stack pour empiler des widgets
        children: [
          Column(
            children: [
              // Ajoutez ici vos autres widgets de contenu
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Exemple de nombre d'éléments dans la liste
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Carte $index'),
                    );
                  },
                ),
              ),
            ],
          ),

          // Le bouton flottant positionné en bas à droite
          Positioned(
            bottom: 16, // Distance du bas de l'écran
            right: 16,  // Distance du bord droit de l'écran
            child: IconButton(
              onPressed: () {
                // Votre action ici
              },
              icon: Icon(Icons.plus_one),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.pink.shade400),
              ),
              color: Colors.white,
              iconSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}
