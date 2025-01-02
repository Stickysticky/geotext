import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserDataConnexion (User user) async {
    final userRef = _firestore.collection('user').doc(user.uid);

    try {
      await userRef.set(
      {
        'firebase_id': user.uid,
        'user_name': '',
        'email': user.email,
        'public_uuid': const Uuid().v4(),
        'created_at': FieldValue.serverTimestamp(),
      },
        SetOptions(mergeFields: ['email', 'public_uuid', 'created_at']),
      );
    } catch (e) {
      print('Erreur lors de l’ajout conditionnel des données utilisateur: $e');
    }

  }

  Future<void> createUserDataConnexion (User user) async {
    final userCollection = _firestore.collection('user');

    try {
      await userCollection.add(
        {
          'firebase_id': user.uid,
          'user_name': '',
          'email': user.email,
          'public_uuid': const Uuid().v4(),
          'created_at': FieldValue.serverTimestamp(),
        }
      );
    } catch (e) {
      print('Erreur lors de l’ajout des données utilisateur: $e');
    }

  }
}