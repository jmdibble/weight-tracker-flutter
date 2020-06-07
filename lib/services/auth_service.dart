import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighttrackertwo/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  FirebaseAuth firebaseAuth;

  AuthService() {
    this.firebaseAuth = FirebaseAuth.instance;
  }

  Future<User> signUp(
      String email, String password, String firstName, String lastName) async {
    try {
      // Create user in auth
      var result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        FirebaseUser firebaseUser = result.user;

        // Create user in Firestore
        if (firebaseUser != null) {
          await Firestore.instance.collection("users").document(firebaseUser.uid).setData(
            {
              "uid": firebaseUser.uid,
              "email": firebaseUser.email,
              "firstName": firstName,
              "lastName": lastName,
              "displayUrl": "",
              "createdAt": DateTime.now(),
            },
          );
          final userDetails = await Firestore.instance
              .collection("users")
              .document(firebaseUser.uid)
              .get();

          User user = User.fromMap(userDetails.data);
          return user;
        }
      }
    } catch (e) {
      String authError = "";
      authError = e.toString();
    }
  }

  Future<User> signIn(String email, String password) async {
    try {
      var result =
          await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (result != null) {
        FirebaseUser firebaseUser = result.user;
        final userDetails =
            await Firestore.instance.collection("users").document(firebaseUser.uid).get();

        User user = User.fromMap(userDetails.data);
        return user;
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    var currentUser = await firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await firebaseAuth.currentUser();
  }

  Future<User> getCurrentUserObject() async {
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();

    final userDetails =
        await Firestore.instance.collection("users").document(firebaseUser.uid).get();

    User user = User.fromMap(userDetails.data);
    return user;
  }

  Future<User> changeEmail(String newEmail, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();

    AuthResult authResult = await user.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(email: user.email, password: password),
    );

    var result = user.updateEmail(newEmail);

    if (result != null) {
      FirebaseUser user = await auth.currentUser();

      await Firestore.instance.collection("users").document(user.uid).updateData(
        {
          "email": newEmail,
        },
      );
    }
  }

  Future<User> changePassword(String password, String newPassword) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();

    AuthResult authResult = await user.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(email: user.email, password: password),
    );

    user.updatePassword(newPassword);
  }

  Future<User> changeUserDetails(String firstName, String lastName) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();

    await Firestore.instance.collection("users").document(user.uid).updateData(
      {
        "firstName": firstName,
        "lastName": lastName,
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> uploadDisplayPicture(File localFile) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    if (localFile != null) {
      print("uploading image");
      var fileExtension = path.extension(localFile.path);
      print(fileExtension);

      final StorageReference storageReference =
          FirebaseStorage.instance.ref().child("users/images/$uid$fileExtension");

      await storageReference.putFile(localFile).onComplete.catchError(
        ((onError) {
          print(onError);
          return false;
        }),
      );

      String url = await storageReference.getDownloadURL();
      print("$url");

      await Firestore.instance
          .collection("users")
          .document("$uid")
          .updateData({"displayUrl": url});
    }
  }
}
