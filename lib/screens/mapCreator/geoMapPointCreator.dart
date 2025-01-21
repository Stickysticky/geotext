import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotext/providers/currentGeoMapPointProvider.dart';

import '../../generated/l10n.dart';
import '../../models/geoMapPoint.dart';
import '../../services/utils.dart';

class GeoMapPointCreator extends ConsumerStatefulWidget {
  const GeoMapPointCreator({super.key});

  @override
  ConsumerState<GeoMapPointCreator> createState() => _GeoMapPointCreatorState();
}

class _GeoMapPointCreatorState extends ConsumerState<GeoMapPointCreator> {
  final _formKey = GlobalKey<FormState>();

  // Variables pour gérer les champs
  String _title = '';
  String _message = '';
  Color _selectedColor = Colors.blue;
  double _radius = 50;

  @override
  Widget build(BuildContext context) {
    GeoMapPoint? point = ref.read(currentGeoMapPointNotifierProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Champ pour le titre
          TextFormField(
            initialValue: point?.title ?? '',
            decoration: InputDecoration(
              labelText: capitalizeFirstLetter(S.of(context).title),
              border: OutlineInputBorder(),
            ),
            onSaved: (value) => _title = value ?? '',
            validator: (value) =>
            (value == null || value.isEmpty) ? capitalizeFirstLetter(S.of(context).titleRequired) : null,
          ),
          const SizedBox(height: 16),

          // Champ pour le message
          TextFormField(
            initialValue: point?.message ?? '',
            decoration: InputDecoration(
              labelText: capitalizeFirstLetter(S.of(context).message),
              border: OutlineInputBorder(),
              alignLabelWithHint: true, // Aligne le label avec le haut du champ
            ),
            maxLines: 5, // Nombre de lignes visibles
            onSaved: (value) => _message = value ?? '',
          ),
          const SizedBox(height: 16),


          // Sélecteur de couleur
          Text(
            '${capitalizeFirstLetter(S.of(context).color)} :',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              _openColorPicker(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Champ pour le rayon
          TextFormField(
            initialValue: '1',//point?.radius.toString() ?? '50',
            decoration: InputDecoration(
              labelText: capitalizeFirstLetter(S.of(context).radiusInfo),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onSaved: (value) => _radius = double.tryParse(value ?? '50') ?? 50,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return capitalizeFirstLetter(S.of(context).radiusRequired);
              }
              final radius = double.tryParse(value);
              if (radius == null || radius <= 0) {
                return capitalizeFirstLetter(S.of(context).radiusValidation);
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Bouton de soumission
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Mettre à jour le GeoMapPoint
                /*ref.read(currentGeoMapPointNotifierProvider.notifier).setGeoMapPoint(
                  GeoMapPoint(
                    title: _title,
                    message: _message,
                    color: _selectedColor,
                    radius: _radius,
                    geoMap: point!.geoMap,
                    geoPoint: point.geoPoint,
                    creator: point.creator,
                  ),
                );*/

                // Fermer ou afficher une confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(capitalizeFirstLetter(S.of(context).pointSaved))),
                );
              }
            },
            child: Text(capitalizeFirstLetter(S.of(context).validate)),
          ),
        ],
      ),
    );
  }

  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(capitalizeFirstLetter(S.of(context).selectAColor)),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(capitalizeFirstLetter(S.of(context).close)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
