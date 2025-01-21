import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importez Riverpod
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customUser.dart';
import 'package:geotext/providers/connectedUserProvider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Ref ref;

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
        CustomUser? myUser = await CustomUser.getFromFirestore(user.uid);

        if(myUser is CustomUser){
          myUser!.geoMapsOwner = await GeoMap.getMyMaps(myUser);
          myUser.geoMapsShared = await GeoMap.getSharedMaps(myUser);
        }
        ref.read(connectedUserNotifierProvider.notifier).setUser(myUser);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);

      return myUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('password');
      await _auth.signOut();

      // Réinitialisez l'état de ConnectedUserNotifier à null
      ref.read(connectedUserNotifierProvider.notifier).setUser(null);
    } catch (e) {
      print(e.toString());
    }
  }
}
