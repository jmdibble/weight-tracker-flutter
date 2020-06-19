import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighttrackertwo/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  FirebaseAuth firebaseAuth;
  User user;

  AuthService() {
    this.firebaseAuth = FirebaseAuth.instance;
  }

  Future<User> createFirebaseUser(
      FirebaseUser firebaseUser, String firstName, String lastName) async {
    // Create user in Firestore
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
    final userDetails =
        await Firestore.instance.collection("users").document(firebaseUser.uid).get();

    user = User.fromMap(userDetails.data);
    return user;
  }

  Future<User> getUserFromFirestore(FirebaseUser firebaseUser) async {
    final userDetails =
        await Firestore.instance.collection("users").document(firebaseUser.uid).get();

    print(userDetails.data);
    if (userDetails.data == null) {
      return null;
    }
    user = User.fromMap(userDetails.data);
    return user;
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
          return createFirebaseUser(firebaseUser, firstName, lastName);
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
        return getUserFromFirestore(await firebaseAuth.currentUser());
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<User> signInWithGoogle() async {
    // Sign in with Google
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    print(googleSignInAuthentication);
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // User credential to sign in to Firebase Auth
    final AuthResult authResult = await firebaseAuth.signInWithCredential(credential);
    print(authResult);
    final FirebaseUser firebaseUser = authResult.user;
    print(firebaseUser);

    // Check if user exists in Firestore, if not add user
    user = await getUserFromFirestore(firebaseUser);
    if (user == null) {
      return await createFirebaseUser(
          firebaseUser, firebaseUser.providerData[0].displayName, "");
    } else {
      return user;
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

    user = User.fromMap(userDetails.data);
    return user;
  }

  Future<User> changeEmail(String newEmail, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await auth.currentUser();

    AuthResult authResult = await firebaseUser.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(email: firebaseUser.email, password: password),
    );

    var result = firebaseUser.updateEmail(newEmail);

    if (result != null) {
      FirebaseUser firebaseUser = await auth.currentUser();

      await Firestore.instance.collection("users").document(firebaseUser.uid).updateData(
        {
          "email": newEmail,
        },
      );
    }
  }

  Future<User> changePassword(String password, String newPassword) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await auth.currentUser();

    AuthResult authResult = await firebaseUser.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(email: firebaseUser.email, password: password),
    );

    firebaseUser.updatePassword(newPassword);
  }

  Future<User> changeUserDetails(String firstName, String lastName) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await auth.currentUser();

    await Firestore.instance.collection("users").document(firebaseUser.uid).updateData(
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
    final FirebaseUser firebaseUser = await auth.currentUser();
    final uid = firebaseUser.uid;

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
