import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import 'customUser.dart';
import 'geoMap.dart';

class GeoMapPoint {
  String _id;
  String _title;
  String? _message;
  GeoMap _geoMap;

  @override
  String toString() {
    return 'GeoMapPoint{_id: $_id, _title: $_title, _message: $_message, _geoMap: $_geoMap, _geoPoint: $_geoPoint, _creator: $_creator}';
  }

  GeoPoint _geoPoint;
  CustomUser _creator;

  GeoMapPoint(this._id, this._title, this._message, this._geoMap, this._geoPoint, this._creator);

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

  GeoPoint get geoPoint => _geoPoint;
  set geoPoint(GeoPoint value) {
    _geoPoint = value;
  }

  CustomUser get creator => _creator;
  set creator(CustomUser value) {
    _creator = value;
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
      final geoPoint = data['geo_point'] as GeoPoint;

      final DocumentReference<Map<String, dynamic>> creatorRef = data['creator'];
      print(creatorRef); // Vérifiez que cela correspond bien à la structure attendue

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
        docSnapshot.id,          // L'ID du GeoMapPoint
        data['title'],
        data['message'],
        geoMap,                  // Le GeoMap associé
        geoPoint,                // Le GeoPoint
        creator,                 // Le créateur
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
    final geoPoint = data['geoPoint'] as GeoPoint;
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
      docSnapshot.id,      // L'ID du document GeoMapPoint
      data['title'],
      data['message'],
      geoMap,               // Le GeoMap associé
      geoPoint,            // Les coordonnées du GeoPoint
      creator,              // Le créateur
    );
  }

  String? get message => _message;

  set message(String? value) {
    _message = value;
  }
}
