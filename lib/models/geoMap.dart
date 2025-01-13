import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geotext/models/customUser.dart';
import 'package:uuid/uuid.dart';

class GeoMap {
  String _id;
  String _title;
  CustomUser _owner;
  bool _isPrivate;
  List<CustomUser> _sharedWith;

  GeoMap({
    String? id,
    required String title,
    required CustomUser owner,
    bool isPrivate = true,
    List<CustomUser>? sharedWith,
  })  : _id = id ?? const Uuid().v4(),
        _title = title,
        _owner = owner,
        _isPrivate = isPrivate,
        _sharedWith = sharedWith ?? [];

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get title => _title;
  CustomUser get owner => _owner;
  bool get isPrivate => _isPrivate;
  List<CustomUser> get sharedWith => _sharedWith;

  set title(String value) => _title = value;
  set owner(CustomUser value) => _owner = value;
  set isPrivate(bool value) => _isPrivate = value;
  set sharedWith(List<CustomUser> value) => _sharedWith = value;

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

  // Méthode pour récupérer une GeoMap depuis Firestore avec un mapId
  static Future<GeoMap> getGeoMapById(String mapId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Récupère le document de la GeoMap par son ID
    final docSnapshot = await _firestore.collection('geoMaps').doc(mapId).get();

    if (!docSnapshot.exists) {
      throw Exception('GeoMap not found');
    }

    final data = docSnapshot.data()!;  // Récupère les données du document Firestore

    // Récupère l'owner de la GeoMap à partir de Firestore
    final ownerId = data['ownerId']; // Récupère l'ID du propriétaire depuis le document Firestore
    final ownerDoc = await _firestore.collection('user').doc(ownerId).get();
    final ownerData = ownerDoc.data()!;

    // Crée un CustomUser pour l'owner avec les informations récupérées
    CustomUser owner = CustomUser(
      ownerId,
      ownerData['userName'],
      ownerData['userDisplayName'],
      ownerData['email'],
      ownerData['createdAt'],
    );

    // Récupère la liste des utilisateurs partagés (sharedWith) à partir de Firestore
    final List<CustomUser> sharedWith = await Future.wait(
      (data['sharedWith'] as List<dynamic>? ?? []).map((userId) async {
        // Récupère les informations complètes de l'utilisateur à partir de Firestore
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final userData = userDoc.data()!;

        // Crée et retourne un CustomUser avec les données de Firestore
        return CustomUser(
          userId,
          userData['userName'],
          userData['userDisplayName'],
          userData['email'],
          userData['createdAt'],
        );
      }).toList(),
    );

    // Crée et retourne un objet GeoMap avec les données récupérées
    return GeoMap(
      id: docSnapshot.id,  // Utilise l'ID du document Firestore comme ID de la carte
      title: data['title'] ?? '',  // Titre de la carte
      owner: owner,  // Le propriétaire, récupéré depuis Firestore
      isPrivate: data['isPrivate'] ?? true,  // La visibilité (privée ou publique)
      sharedWith: sharedWith,  // Les utilisateurs avec qui la carte est partagée
    );
  }

  // Méthode pour sauvegarder une GeoMap sur Firestore
  Future<void> saveToFirestore() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Préparer les données à sauvegarder
    final data = {
      'title': _title,
      'ownerId': _owner.id,  // ID de l'owner
      'isPrivate': _isPrivate,
      'sharedWith': _sharedWith.map((user) => user.id).toList(),  // Liste des IDs des utilisateurs partagés
    };

    // Si la GeoMap a un ID existant, on met à jour le document Firestore existant
    if (_id.isNotEmpty) {
      await _firestore.collection('geoMaps').doc(_id).set(data);
    } else {
      // Sinon, on crée un nouveau document avec un ID généré
      final newDocRef = _firestore.collection('geoMaps').doc();
      await newDocRef.set(data);
      // Met à jour l'ID local après avoir sauvegardé
      _id = newDocRef.id;
    }
  }

  // Méthode pour récupérer toutes les cartes associées à un CustomUser (cartes où l'utilisateur est propriétaire ou partagé)
  static Future<List<GeoMap>> getMyMaps(CustomUser user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Récupérer les cartes dont l'utilisateur est propriétaire
    final ownerMapsSnapshot = await firestore
        .collection('geoMap')
        .where('ownerId', isEqualTo: user.id)
        .get();

    // Créer une liste de GeoMap à partir des résultats
    List<GeoMap> maps = [];

    // Ajouter les cartes où l'utilisateur est propriétaire
    for (var map in ownerMapsSnapshot.docs) {
      maps.add(await GeoMap.getGeoMapById(map.id));
    }

    return maps;
  }

  // Méthode pour récupérer toutes les cartes partagées avec un CustomUser
  static Future<List<GeoMap>> getSharedMaps(CustomUser user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Récupérer les cartes partagées avec l'utilisateur
    final sharedMapsSnapshot = await firestore
        .collection('geoMap')
        .where('sharedWith', arrayContains: user.id)
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
