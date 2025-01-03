
import 'package:firebase_auth/firebase_auth.dart';
import '../models/customUser.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(CustomUser.constructFromFirebaseUser);
  }

  Future signIn (String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = result.user;
      CustomUser? myUser = CustomUser.constructFromFirebaseUser(user);

      return myUser;

    } catch(e){
      print (e.toString());
      return null;
    }
  }

  //sign in with email, password

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password
      );
      User? user = result.user;
      CustomUser? myUser = CustomUser.constructFromFirebaseUser(user);

      //if(myUser is CustomUser){
        myUser?.register();
      //}

      return myUser;
    }catch(e){
      return e;
    }
  }

  //sign out

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}