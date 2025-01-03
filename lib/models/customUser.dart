import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CustomUser {
  final String _uid;
  String? _userName;
  String? _userDisplayName;
  String _email;
  final FieldValue _createdAt;
  FieldValue? _deletedAt = null;

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

  set deletedAt(FieldValue? value) {
    _deletedAt = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  FieldValue get createdAt => _createdAt;

  FieldValue? get deletedAt => _deletedAt;

  static CustomUser? constructFromFirebaseUser(User? user){
    return user != null ? CustomUser(
        user.uid,
      user.displayName,
      user.displayName,
      user.email!,
      FieldValue.serverTimestamp()
    ) : null;
  }

  Future<void> register () async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userRef = _firestore.collection('user').doc(uid);

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