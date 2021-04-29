import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/searchFunctions/searchParkingButtons.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/models/map.dart';
import 'package:mps/views/signin.dart';
import 'package:mps/views/mainpageuser.dart';

List<QueryDocumentSnapshot> list = [];

class HomeClient extends StatefulWidget {
  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
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
          Map((lista) {
            setState(() {
              list = lista;
            });
            list = lista;
          }),
          Text(list.length.toString()),
          SearchParkingButtons(list),
        ]),
      ),
    );
  }
}
