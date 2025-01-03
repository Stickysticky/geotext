import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CustomUser {
  final String _uid;
  String? _userName;
  String _email;
  final String _publicUid;
  final FieldValue _createdAt;
  FieldValue? _deletedAt = null;

  CustomUser(
      this._uid, this._userName, this._email, this._publicUid, this._createdAt);

  @override
  String toString() {
    return 'CustomUser{_uid: $_uid, _userName: $_userName, _email: $_email, _publicUid: $_publicUid, _createdAt: $_createdAt, _deletedAt: $_deletedAt}';
  }

  String get uid => _uid;
  String? get userName => _userName;

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

  String get publicUid => _publicUid;

  FieldValue get createdAt => _createdAt;

  FieldValue? get deletedAt => _deletedAt;

  static CustomUser? constructFromFirebaseUser(User? user){
    return user != null ? CustomUser(
        user.uid,
      user.displayName,
      user.email!,
      const Uuid().v4(),
      FieldValue.serverTimestamp()
    ) : null;
  }

  Future<void> register () async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userRef = _firestore.collection('user').doc(uid);

    try {
      await userRef.set({
        'user_name': userName,
        'email': email,
        'public_uuid': publicUid,
        'created_at': createdAt,
        'deleted_at': deletedAt
      });

    } catch (e) {
      print('Erreur lors de la création de l’utilisateur : $e');
    }
  }
}