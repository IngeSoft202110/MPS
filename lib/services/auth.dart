import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mps/helpfunctions/sharedpref_help.dart';
import 'package:mps/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email.replaceAll("@gmail.com", ""),
        "name": name,
        "profileUrl": userDetails.photoURL
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

    if (result != null) {
      SharedPreferenceHelp().saveUserEmail(userDetails.email);
      SharedPreferenceHelp().saveUserId(userDetails.uid);
      SharedPreferenceHelp().saveDisplayName(userDetails.displayName);
      SharedPreferenceHelp().saveUserProfileUrl(userDetails.photoURL);

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email.replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "profileUrl": userDetails.photoURL
      };


      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap, typeUser)
          .then((value) {
        if (typeUser == 'cliente') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeClient()));
        } else if (typeUser == 'socio') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePartner()));
        }
      });
    }
  }
  
  getUserByname(String username) async{
    return await FirebaseFirestore.instance.collection("users")
    .where("name", isEqualTo: username)
    .get(); 
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection("users")
    .where("email", isEqualTo: userEmail)
    .get(); 
  }

  addConversationMenssages(String chatRoomId, menssageMap){
    
    FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatRoomId)
    .collection("chats")
    .add(menssageMap).catchError((e){print(e.toString());});
    
  }

  getConversationMenssages(String chatRoomId) async{

    return await FirebaseFirestore.instance.collection("ChatRoom")
    .doc(chatRoomId)
    .collection("chats")
    .orderBy("time", descending: false)
    .snapshots();

  }

  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
    .where("users", arrayContains: userName)
    .snapshots();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }


}
