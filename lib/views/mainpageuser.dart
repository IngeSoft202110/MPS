import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPageUser extends StatefulWidget {
  @override
  _MainPageUserState createState() => _MainPageUserState();
}

class _MainPageUserState extends State<MainPageUser> {
  //User user = AuthMethods().getCurrentUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home())),
        ),
        backgroundColor: Colors.blue[900],
        title: Text("Managing Parking System"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 140, vertical: 30),
            child: Center(
              child: Image(image: AssetImage('assets/Logo_Acron.png')),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                "User Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
