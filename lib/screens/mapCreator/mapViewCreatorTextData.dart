import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotext/providers/currentMapProvider.dart';
import 'package:latlong2/latlong.dart';

import '../../commonWidgets/customAppBar.dart';
import '../../models/customUser.dart';
import '../../models/geoMap.dart';
import '../../generated/l10n.dart';
import '../../providers/connectedUserProvider.dart';
import '../../services/utils.dart';

class MapViewCreatorTextData extends ConsumerStatefulWidget {
  const MapViewCreatorTextData({super.key});

  @override
  ConsumerState<MapViewCreatorTextData> createState() => _MapViewCreatorTextDataState();
}

class _MapViewCreatorTextDataState extends ConsumerState<MapViewCreatorTextData> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  bool _isPrivate = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isCreation = args?['isCreation'] ?? true;

    //GeoMap? geoMap = ref.watch(currentMapNotifierProvider);

    GeoMap? geoMap = args?['geoMap'];
    print(geoMap);

    if (geoMap != null) {
      _title = geoMap.title;
      _isPrivate = geoMap.isPrivate;
    }

    CustomUser currentUser = ref.read(connectedUserNotifierProvider)!;

    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: CustomAppBar(title: capitalizeFirstLetter(isCreation ? S.of(context).mapCreation : S.of(context).mapModification)),
      floatingActionButton: IconButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save(); // Sauvegarder les valeurs du formulaire
            await _createGeoMap(currentUser, geoMap); // Appeler la fonction de création
          }
        },
        icon: const Icon(Icons.arrow_right), // Icône "Valider"
        style: IconButton.styleFrom(
          backgroundColor: Colors.pink.shade400,
        ),
        color: Colors.white,
        iconSize: 40,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 36.0, 16.0, 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Titre du GeoMap
              TextFormField(
                decoration: InputDecoration(
                  labelText: capitalizeFirstLetter(S.of(context).title),
                  labelStyle: TextStyle(
                    fontSize: 30,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                    ),
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red, // Couleur du texte de l'erreur
                    fontSize: 18, // Taille du texte de l'erreur
                    fontWeight: FontWeight.bold, // Éventuellement, mettre en gras
                  ),
                ),
                initialValue: _title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return capitalizeFirstLetter(S.of(context).titleRequired);
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
                style: TextStyle(
                  //decorationColor: Colors.pink.shade400,
                ),
              ),

              const SizedBox(height: 16),

              // Option de visibilité (privée ou publique)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    capitalizeFirstLetter(S.of(context).isPrivate),
                    style: TextStyle(
                        fontSize: 25,
                    ),

                  ),
                  Switch(
                    activeColor: Colors.pink.shade400,
                    value: _isPrivate,
                    onChanged: (value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createGeoMap(CustomUser currentUser, [GeoMap? initialGeoMap]) async {
    bool isCreation = initialGeoMap == null;

    GeoMap geoMap = GeoMap(
      id: !isCreation ? initialGeoMap.id : null,
      title: _title!,
      owner: currentUser,
      isPrivate: _isPrivate,
      initialCenter: !isCreation ? initialGeoMap.initialCenter : LatLng(48.8566, 2.3522),
    );

    ref.watch(currentMapNotifierProvider.notifier).setGeoMap(geoMap);

    Navigator.pushNamed(context, '/map_creator_init_point', arguments: {'isCreation': isCreation});
  }
}
