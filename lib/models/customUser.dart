import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'geoMap.dart';

class CustomUser {
  final String _id;
  String? _userName;
  String? _userDisplayName;
  String _email;
  final Timestamp _createdAt;
  Timestamp? _deletedAt = null;
  List<GeoMap> _geoMaps = [];

  CustomUser(
      this._id, this._userName, this._userDisplayName, this._email, this._createdAt);

  @override
  String toString() {
    return 'CustomUser{_id: $_id, _userName: $_userName, _userDisplayName: $_userDisplayName, _email: $_email, _createdAt: $_createdAt, _deletedAt: $_deletedAt}';
  }

  String get id => _id;
  String? get userName => _userName;

  String? get userDisplayName => _userDisplayName;

  set userDisplayName(String? value) {
    _userDisplayName = value;
  }

  set userName(String? value) {
    _userName = value;
  }

  set deletedAt(Timestamp? value) {
    _deletedAt = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  Timestamp get createdAt => _createdAt;

  Timestamp? get deletedAt => _deletedAt;

  set displayName(String? displayName) {}

  List<GeoMap> get geoMaps => _geoMaps;

  set geoMaps(List<GeoMap> value) {
    _geoMaps = value;
  }

  static CustomUser? constructFromFirebaseUser(User? user){
    return user != null ? CustomUser(
        user.uid,
      user.displayName,
      user.displayName,
      user.email!,
        Timestamp.now()
    ) : null;
  }

  static CustomUser? constructFromFireStoreUser(User? user){
    return user != null ? CustomUser(
        user.uid,
        user.displayName,
        user.displayName,
        user.email!,
        Timestamp.now()
    ) : null;
  }

  static Future<CustomUser?> getFromFirestore(String uuid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('user').doc(uuid);

    try {
      // Récupération du document Firestore
      final doc = await userRef.get();

      if (!doc.exists) {
        print('Utilisateur avec l’ID $uuid non trouvé.');
        return null;
      }

      // Extraction des données du document
      final data = doc.data();
      if (data == null) {
        print('Aucune donnée disponible pour l’utilisateur $uuid.');
        return null;
      }

      // Création de l’objet CustomUser à partir des données Firestore
      return CustomUser(
        uuid,
        data['user_name'] as String?,
        data['display_name'] as String?,
        data['email'] as String,
        data['created_at'] as Timestamp,
      )..deletedAt = data['deleted_at'] as Timestamp?;
    } catch (e) {
      print('Erreur lors de la récupération de l’utilisateur : $e');
      return null;
    }
  }


  Future<void> save () async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('user').doc(id);

    try {
      await userRef.set({
        'user_name': userName,
        'display_name': userDisplayName,
        'email': email,
        'created_at': createdAt,
        'deleted_at': deletedAt
      });

    } catch (e) {
      print('Erreur lors de la création de l’utilisateur : $e');
    }
  }

  // Méthode pour récupérer toutes les cartes associées à un CustomUser (cartes où l'utilisateur est propriétaire ou partagé)
  static Future<List<GeoMap>> getMyMaps(CustomUser user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Récupérer les cartes dont l'utilisateur est propriétaire
    final ownerMapsSnapshot = await firestore
        .collection('geoMaps')
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
        .collection('geoMaps')
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