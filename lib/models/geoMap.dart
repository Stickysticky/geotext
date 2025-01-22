import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geotext/models/customUser.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import 'geoMapPoint.dart';

class GeoMap {
  String _id;
  String _title;
  CustomUser _owner;
  bool _isPrivate;
  List<CustomUser> _sharedWith;
  LatLng _initialCenter;
  List<GeoMapPoint> _geoMapPoints;

  GeoMap({
    String? id,
    required String title,
    required CustomUser owner,
    bool isPrivate = true,
    List<CustomUser>? sharedWith,
    LatLng? initialCenter,
    List<GeoMapPoint>? geoMapPoints,
  })  : _id = id ?? const Uuid().v4(),
        _title = title,
        _owner = owner,
        _isPrivate = isPrivate,
        _sharedWith = sharedWith ?? [],
        _initialCenter = initialCenter ?? LatLng(48.8566, 2.3522),
        _geoMapPoints = geoMapPoints ?? []
  ;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  List<GeoMapPoint> get geoMapPoints => _geoMapPoints;

  set geoMapPoints(List<GeoMapPoint> value) {
    _geoMapPoints = value;
  }

  LatLng get initialCenter => _initialCenter;

  set initialCenter(LatLng value) {
    _initialCenter = value;
  }

  String get title => _title;
  CustomUser get owner => _owner;
  bool get isPrivate => _isPrivate;
  List<CustomUser> get sharedWith => _sharedWith;

  set title(String value) => _title = value;
  set owner(CustomUser value) => _owner = value;
  set isPrivate(bool value) => _isPrivate = value;
  set sharedWith(List<CustomUser> value) => _sharedWith = value;

  void addGeoMapPoint(GeoMapPoint geoMapPoint) {
    if (!_geoMapPoints.contains(geoMapPoint)) {
      _geoMapPoints.add(geoMapPoint);
    }
  }

  void removeGeoMapPoint(GeoMapPoint geoMapPoint) {
    _geoMapPoints.remove(geoMapPoint);
  }

  void addSharedUser(CustomUser user) {
    if (!_sharedWith.contains(user)) {
      _sharedWith.add(user);
    }
  }

  void removeSharedUser(CustomUser user) {
    _sharedWith.remove(user);
  }

  @override
  String toString() {
    return 'Map(title: $_title, owner: ${_owner.id}, isPrivate: $_isPrivate, sharedWith: ${_sharedWith.map((u) => u.id).toList()})';
  }

  static Future<GeoMap> getGeoMapById(String mapId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Récupère le document de la GeoMap par son ID
    final docSnapshot = await firestore.collection('geo_map').doc(mapId).get();

    if (!docSnapshot.exists) {
      throw Exception('GeoMap not found');
    }

    final data = docSnapshot.data()!; // Récupère les données du document Firestore

    // Récupère l'owner de la GeoMap en tant que DocumentReference
    final DocumentReference ownerRef = data['owner'];
    final ownerDoc = await ownerRef.get(); // Charge les données du propriétaire
    final ownerData = ownerDoc.data() as Map<String, dynamic>;

    // Crée un CustomUser pour l'owner
    CustomUser owner = CustomUser(
      ownerRef.id, // ID de l'utilisateur
      ownerData['user_name'],
      ownerData['display_name'],
      ownerData['email'],
      ownerData['created_at'],
    );

    // Récupère la liste des utilisateurs partagés (sharedWith)
    final List<CustomUser> sharedWith = await Future.wait(
      (data['shared_with'] as List<dynamic>? ?? []).map((userId) async {
        final userDoc = await firestore.collection('user').doc(userId).get();
        final userData = userDoc.data() as Map<String, dynamic>;

        return CustomUser(
          userId,
          userData['user_name'],
          userData['display_name'],
          userData['email'],
          userData['created_at'],
        );
      }).toList(),
    );

    // Retourne l'objet GeoMap
    return GeoMap(
      id: docSnapshot.id,
      title: data['title'] ?? '',
      owner: owner,
      isPrivate: data['is_private'] ?? true,
      sharedWith: sharedWith,
      initialCenter: LatLng(
        data['initial_center']['latitude'],
        data['initial_center']['longitude'],
      ),
    );
  }


  Future<void> saveToFirestore() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Préparer les données à sauvegarder
    final data = {
      'title': _title,
      'owner': _firestore.collection('user').doc(_owner.id),
      'is_private': _isPrivate,
      'shared_with': _sharedWith.map((user) => user.id).toList(),
      'initial_center': {
        'latitude': _initialCenter.latitude,  // Utilise latitude et longitude de _initialCenter
        'longitude': _initialCenter.longitude,
      },
    };

    // Mise à jour ou création d'un nouveau document
    if (_id.isNotEmpty) {
      await _firestore.collection('geo_map').doc(_id).set(data);
    } else {
      final newDocRef = _firestore.collection('geo_map').doc();
      await newDocRef.set(data);
      _id = newDocRef.id;
    }
  }


  static Future<List<GeoMap>> getMyMaps(CustomUser user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final ownerRef = firestore.collection('user').doc(user.id);
    final ownerMapsSnapshot = await firestore
        .collection('geo_map')
        .where('owner', isEqualTo: ownerRef)
        .get();

    // Créer une liste de GeoMap à partir des résultats
    List<GeoMap> maps = [];

    // Ajouter les cartes où l'utilisateur est propriétaire
    for (var map in ownerMapsSnapshot.docs) {
      Map<String,dynamic> dataMap = map.data();
      print(dataMap['initial_center']);
      GeoMap geoMap = GeoMap(
        id: map.id,
        title: dataMap['title'],
        owner: user,
        isPrivate: dataMap['is_private'],
        initialCenter:  LatLng(
          dataMap['initial_center']['latitude'],
          dataMap['initial_center']['longitude'],
        ),
      );

      for (var fireUser in dataMap['shared_with']){
        print(fireUser); //TODO
      }

      maps.add(geoMap);
    }

    return maps;
  }

  static Future<List<GeoMap>> getSharedMaps(CustomUser user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final ownerRef = firestore.collection('user').doc(user.id);

    // Récupérer les cartes partagées avec l'utilisateur
    final sharedMapsSnapshot = await firestore
        .collection('geo_map')
        .where('shared_with', arrayContains: ownerRef)
        .get();

    // Créer une liste de GeoMap à partir des résultats
    List<GeoMap> maps = [];

    // Ajouter les cartes où l'utilisateur est dans la liste des partagés
    for (var map in sharedMapsSnapshot.docs) {
      maps.add(await GeoMap.getGeoMapById(map.id));
    }

    return maps;
  }
}
