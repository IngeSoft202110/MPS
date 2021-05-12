import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/searchButton.dart';
import 'package:mps/views/searchList.dart';
import 'package:mps/views/mainpageuser.dart';
import 'package:mps/views/userLogSign/signin.dart';

import '../services/database.dart';
import 'displayList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot> lista;
  Stream<QuerySnapshot> allDocuments;

  @override
  void initState() {
    allDocuments = Queries().allDocuments();
    super.initState();
  }

  Future searchRanking() async {
    //lista = await Queries().ranking();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DisplayList(lista: lista)));
  }

  Future searchPriceCar() async {
    //lista = await Queries().priceCar();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DisplayList(lista: lista)));
  }

  Future searchPriceMot() async {
    //lista = await Queries().pricemMotorcycle();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DisplayList(lista: lista)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Managing Parking System"),
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
      body: Container(
        child: Column(
          children: [
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
                  "Buscar Parqueadero",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Divider(color: Colors.black, indent: 19, endIndent: 19),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: GestureDetector(
                              child: Text("Cercanía"),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchList()));
                              },
                            ),
                          ),
                        ),
                        Divider(color: Colors.black, indent: 19, endIndent: 19),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: GestureDetector(
                                child: Text("Precio"),
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchButton()));
                                },
                              )),
                        ),
                        Divider(color: Colors.black, indent: 19, endIndent: 19),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: GestureDetector(
                              child: Text("Ranking"),
                              onTap: () {
                                searchRanking();
                              },
                            ),
                          ),
                        ),
                        Divider(color: Colors.black, indent: 19, endIndent: 19),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.blue[900],
              width: double.maxFinite,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              child: Text(
                "Parqueaderos destacados",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),

            //Poner parqueaderos de 4 a 5 estrellas

            /*Row(
              children: [Expanded(child: TextField()), Icon(Icons.search)],
            )*/
          ],
        ),
      ),
    );
  }
}
