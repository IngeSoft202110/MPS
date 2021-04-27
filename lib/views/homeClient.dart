import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/models/map.dart';
import 'package:mps/views/signin.dart';
import 'package:mps/views/mainpageuser.dart';
import 'dart:ui';

int _map;

class HomeClient extends StatefulWidget {
  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  String address = "", latitude, longitude, error = "";
  List<QueryDocumentSnapshot> lista;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("HOME"),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPageUser()));
                        }),
                    Icon(Icons.exit_to_app),
                  ],
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Map(
            (map) {
              _map = map;
              setState(() {
                Map((map) {
                  _map = map;
                });
              });
            },
          ),
        ]),
      ),
    );
  }
}

class ErrorDialog extends StatefulWidget {
  final String title;
  final String content;
  ErrorDialog(this.title, this.content);

  @override
  _ErrorDialog createState() => _ErrorDialog(title, content);
}

class _ErrorDialog extends State<ErrorDialog> {
  String title;
  String content;
  _ErrorDialog(this.title, this.content);

  Widget alert() {
    return new BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: new Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue[900])),
        content: new Text(content, style: TextStyle(color: Colors.black)),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blue[100],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Aceptar"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return alert();
  }
}
