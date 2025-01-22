import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import 'customUser.dart';
import 'geoMap.dart';

class GeoMapPoint {
  String _id;
  String _title;
  String? _message;
  GeoMap _geoMap;
  GeoPoint _geoPoint;
  CustomUser _creator;
  Color _color;

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }

  double _radius;

  @override
  String toString() {
    return 'GeoMapPoint{_id: $_id, _title: $_title, _message: $_message, _geoMap: $_geoMap, _geoPoint: $_geoPoint, _creator: $_creator, _color: $_color, _radius: $_radius}';
  }

  GeoMapPoint({
    String? id,
    required String title,
    String? message,
    required GeoMap geoMap,
    required GeoPoint geoPoint,
    required CustomUser creator,
    Color? color, // Paramètre optionnel, valeur par défaut si null
    double radius = 10.0, // Valeur par défaut
  })  : _id = id ?? const Uuid().v4(),
        _title = title,
        _message = message,
        _geoMap = geoMap,
        _geoPoint = geoPoint,
        _creator = creator,
        _color = color ?? Colors.pink.shade400, // Définit une couleur par défaut
        _radius = radius;


  String get id => _id;
  set id(String value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  GeoMap get geoMap => _geoMap;
  set geoMap(GeoMap value) {
    _geoMap = value;
  }

  String? get message => _message;

  set message(String? value) {
    _message = value;
  }

  double get radius => _radius;

  set radius(double value) {
    _radius = value;
  }

  GeoPoint get geoPoint => _geoPoint;
  set geoPoint(GeoPoint value) {
    _geoPoint = value;
  }

  CustomUser get creator => _creator;
  set creator(CustomUser value) {
    _creator = value;
  }

  Future<void> saveGeoMapPointToFirestore() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Préparer les données à sauvegarder
    final data = {
      'title': _title,
      'message': _message ?? '', // Stocke un message vide si null
      'geo_map': _firestore.collection('geo_map').doc(_geoMap.id), // Référence au GeoMap
      'geo_point': {
        'latitude': _geoPoint.latitude,
        'longitude': _geoPoint.longitude,
      },
      'creator': _firestore.collection('user').doc(_creator.id), // Référence au créateur
      'color': _color.value, // Sauvegarde la couleur sous forme d'entier
      'radius': _radius, // Rayon en double
    };

    // Mise à jour ou création d'un nouveau document
    if (_id.isNotEmpty) {
      await _firestore.collection('geo_map_point').doc(_id).set(data);
    } else {
      final newDocRef = _firestore.collection('geo_map_point').doc();
      await newDocRef.set(data);
      _id = newDocRef.id; // Met à jour l'ID dans l'objet
    }
  }


  static Future<List<GeoMapPoint>> getGeoMapPointsByGeoMap(GeoMap geoMap) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Référence au GeoMap
    final geoMapRef = firestore.collection('geo_map').doc(geoMap.id);

    // Requête pour récupérer les GeoMapPoints associés à ce GeoMap
    final querySnapshot = await firestore
        .collection('geo_map_point')
        .where('geo_map', isEqualTo: geoMapRef)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('No GeoMapPoints found for this GeoMap');
    }

    // Liste des GeoMapPoints
    List<GeoMapPoint> geoMapPoints = [];

    for (var docSnapshot in querySnapshot.docs) {
      final data = docSnapshot.data();

      // Récupérer le GeoPoint
      final geoPoint = GeoPoint(data['geo_point']['latitude'], data['geo_point']['longitude']);
      final DocumentReference<Map<String, dynamic>> creatorRef = data['creator'];

// Récupérez l'ID du document à partir de la référence
      final creatorDoc = await creatorRef.get();

      if (!creatorDoc.exists) {
        throw Exception('Creator not found in Firestore');
      }

      final creatorData = creatorDoc.data()!;
      final creator = CustomUser(
        creatorDoc.id,
        creatorData['user_name'],
        creatorData['user_display_name'],
        creatorData['email'],
        creatorData['created_at'],
      );

      // Ajouter un GeoMapPoint à la liste
      geoMapPoints.add(GeoMapPoint(
        id: docSnapshot.id,          // L'ID du GeoMapPoint
        title: data['title'],
        message :data['message'],
        color: Color(data['color'] as int),
        radius: data['radius'],
        geoMap: geoMap,                  // Le GeoMap associé
        geoPoint: geoPoint,                // Le GeoPoint
        creator: creator,                 // Le créateur
      ));
    }

    return geoMapPoints;
  }


  // Récupérer un GeoMapPoint depuis Firestore via l'id de GeoMapPoint
  static Future<GeoMapPoint> getGeoMapPointById(String id) async { // à vérifier
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Récupérer le document du GeoMapPoint via son ID
    final docSnapshot = await _firestore.collection('geoMapPoints').doc(id).get();

    if (!docSnapshot.exists) {
      throw Exception('GeoMapPoint not found');
    }

    final data = docSnapshot.data()!;

    // Récupérer le GeoPoint
    final geoPoint = GeoPoint(data['geo_point']['latitude'], data['geo_point']['longitude']);
    final geoLatLng = LatLng(geoPoint.latitude, geoPoint.longitude);

    // Récupérer le GeoMap
    final geoMapId = data['geoMapId'];
    final geoMapDoc = await _firestore.collection('geoMaps').doc(geoMapId).get();
    final geoMapData = geoMapDoc.data()!;
    final geoMap = GeoMap(
      id: geoMapDoc.id,
      title: geoMapData['title'] ?? '',
      owner: CustomUser(
        geoMapData['ownerId'],
        geoMapData['userName'],
        geoMapData['userDisplayName'],
        geoMapData['email'],
        geoMapData['createdAt'],
      ),
      isPrivate: geoMapData['is_private'] ?? true,
      sharedWith: [], // Ajouter la logique pour récupérer les utilisateurs partagés si nécessaire
      initialCenter: geoLatLng,
    );

    // Récupérer le créateur (CustomUser)
    final creatorId = data['creatorId'];
    final creatorDoc = await _firestore.collection('users').doc(creatorId).get();
    final creatorData = creatorDoc.data()!;
    final creator = CustomUser(
      creatorId,
      creatorData['userName'],
      creatorData['userDisplayName'],
      creatorData['email'],
      creatorData['createdAt'],
    );

    return GeoMapPoint(
      id: docSnapshot.id,      // L'ID du document GeoMapPoint
      title: data['title'],
      message: data['message'],
      color: Color(data['color'] as int),
      radius: data['radius'],
      geoMap: geoMap,               // Le GeoMap associé
      geoPoint: geoPoint,            // Les coordonnées du GeoPoint
      creator: creator,              // Le créateur
    );
  }


}
