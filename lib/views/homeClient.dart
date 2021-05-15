import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/models/parkingLots.dart';
import 'package:mps/searchFunctions/searchParkingButtons.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/models/map.dart';
import 'package:mps/views/mainpageuser.dart';
import 'package:mps/views/userLogSign/selectUser.dart';
import 'package:mps/views/userLogSign/signin.dart';
import 'package:provider/provider.dart';

List<QueryDocumentSnapshot> list = [];

class HomeClient extends StatefulWidget {
  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  @override
  Widget build(BuildContext context) {
    final parkingList = Provider.of<ParkingLots>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[900],
        title: Text("HOME"),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SelectUser()),
                    ModalRoute.withName('/'));
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
              parkingList.list = lista;
            });
            list = lista;
          }),
          SearchParkingButtons(parkingList.list),
        ]),
      ),
    );
  }
}
