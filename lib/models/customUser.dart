import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {
  final String _uid;
  String? _userName;
  String? _userDisplayName;
  String _email;
  final Timestamp _createdAt;
  Timestamp? _deletedAt = null;

  CustomUser(
      this._uid, this._userName, this._userDisplayName, this._email, this._createdAt);

  @override
  String toString() {
    return 'CustomUser{_uid: $_uid, _userName: $_userName, _userDisplayName: $_userDisplayName, _email: $_email, _createdAt: $_createdAt, _deletedAt: $_deletedAt}';
  }

  String get uid => _uid;
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
    final userRef = firestore.collection('user').doc(uid);

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
}