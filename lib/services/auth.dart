import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importez Riverpod
import 'package:firebase_auth/firebase_auth.dart';
import '../models/customUser.dart';
import 'package:geotext/providers/connectedUserProvider.dart'; // Importez votre notifier

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Ref ref; // Ajoutez une référence pour accéder aux providers

  AuthService(this.ref);

  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(CustomUser.constructFromFirebaseUser);
  }

  Future<CustomUser?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if(user is User){
        CustomUser? myUser = await CustomUser.getFromFirestore(user!.uid);
        ref.read(connectedUserNotifierProvider.notifier).setUser(myUser);

        return myUser;
      } else {
        return null;
      }


    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<CustomUser?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      CustomUser? myUser = CustomUser.constructFromFirebaseUser(user);

      // Sauvegardez l'utilisateur si nécessaire
      myUser?.save();

      // Mettez à jour l'état de ConnectedUserNotifier
      ref.read(connectedUserNotifierProvider.notifier).setUser(myUser);

      return myUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();

      // Réinitialisez l'état de ConnectedUserNotifier à null
      ref.read(connectedUserNotifierProvider.notifier).setUser(null);
    } catch (e) {
      print(e.toString());
    }
  }
}
