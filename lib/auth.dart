import 'package:firebase_auth/firebase_auth.dart';

import 'model/storage_services.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }


  Future<void> createUserWithEmailAndPassword(
      {required String email,
        required String password,
        required String name,
        required int id,
        required String section,
        required DateTime? birthdate,
        required String aboutMe,
        String? fb,String? ig, String? git, String? twtr}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    Map<String,dynamic> userInfoMap = {
      "email": email,
      "name": name,
      "id": id,
      "section": section,
      "birthdate":birthdate,
      "aboutMe": aboutMe,
      "fb": "https://www.facebook.com/",
      "ig": "https://www.instagram.com/",
      "git": "https://github.com/",
      "twtr": "https://twitter.com/"
    };

    if(userCredential != null){
      Storage().addUserInfoToDB(_firebaseAuth.currentUser!.uid, userInfoMap);
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}