import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mps/helpfunctions/sharedpref_help.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/homeClient.dart';
import 'package:mps/views/homePartner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  Future signInEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User userDetails = userCredential.user;
      return userDetails;
    } on FirebaseAuthException catch (e) {
      print("error");
      throw e;
    }
  }

  Future signUpWithEmailAndPassword(BuildContext context, String email,
      String password, String name, String typeUser) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      //await auth.signInWithEmailAndPassword(email: email, password: password);
      User userDetails = userCredential.user;

      List favorite = [];
      List visited = [];

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email.split("@")[0],
        "name": name,
        "profileUrl": userDetails.photoURL,
        "favorites": favorite,
        "visited": visited
      };

      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap, typeUser)
          .then((value) {
        // if (typeUser == 'cliente') {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => HomeClient()));
        // } else if (typeUser == 'socio') {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => HomePartner()));
        // }
      });

      return userDetails;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      throw e;
    } //catch (e) {
    //   print(e.toString());
    // }
  }

  signInWithGoogle(BuildContext context, String typeUser) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User userDetails = result.user;
    List favorite = [];
    List visited = [];

    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email.replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "profileUrl": userDetails.photoURL,
        "favorites": favorite,
        "visited": visited
      };

      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap, typeUser)
          .then((value) async {
        if (typeUser == 'cliente') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeClient()));
        } else if (typeUser == 'socio') {
          List<QueryDocumentSnapshot> lista = [];
          lista = await Queries().owner();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePartner(lista: lista)));
        }
      });
    }
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }
}
