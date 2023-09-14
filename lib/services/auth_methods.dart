import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart' as model;
import 'package:socialmedia/services/storage_methods.dart';

class AuthMethod {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = firebaseAuth.currentUser!;

    DocumentSnapshot snapshot =
        await firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snapshot);
  }

  // Create new User!!!

  Future<String> signupmethod({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Error Occured";

    try {
      if (username.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // registering a new user

//  save at auth
        UserCredential credential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        var uid = credential.user!.displayName;

        print(uid);

        String profilePhotoUrl = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false);

        model.User user = model.User(
          username: username,
          uid: credential.user!.uid,
          email: email,
          bio: bio,
          photoUrl: profilePhotoUrl,
          following: [],
          favorites: [],
          followers: [],
        );

// save  at firestore
        await firebaseFirestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(
              user.toJson(),
            );
        res = "Account Created Successfully";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

// loggin
  Future<String> loginMethod({
    required String email,
    required String password,
  }) async {
    String res = "Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Login Succes";
      } else {
        res = "Please enter  all the fiels";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
