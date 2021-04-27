import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/services/database.dart';
import 'package:mps/models/map.dart';
import 'package:mps/views/signin.dart';
import 'package:mps/views/mainpageuser.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mps/views/displayList.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';

int _map;

class HomeClient extends StatefulWidget {
  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  String address = "", latitude, longitude, error = "";
  List<QueryDocumentSnapshot> lista;
  Stream<QuerySnapshot> allDocuments;
  List<Location> locations;

  Future search(String addr) async {
    locations =
        await Queries().locationFromAddress(addr + ", Bogota, Colombia");

    lista = await Queries()
        .nearby(locations.first.latitude, locations.first.longitude);
    if (lista.isNotEmpty) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DisplayList(lista: lista)));
    } else {
      setState(() {
        error = "No hubo resultados para la búsqueda";
      });
    }
  }

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
        child: Column(children: [
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
          //buttons(),
        ]),
      ),
    );
  }
}
