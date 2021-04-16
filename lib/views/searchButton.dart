import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/database.dart';

import 'displayList.dart';
import 'home.dart';

class SearchButton extends StatefulWidget {
  @override
  _SearchButton createState() => _SearchButton();
}

class _SearchButton extends State<SearchButton> {
  List<QueryDocumentSnapshot> lista;
  Stream<QuerySnapshot> allDocuments;

  @override
  void initState() {
    allDocuments = Queries().allDocuments();
    super.initState();
  }
  Future searchPriceCar()async {
    lista = await Queries()
        .priceCar();
                              
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => DisplayList(lista: lista)));
  }
  Future searchPriceMot()async {
    lista = await Queries()
        .pricemMotorcycle();
                              
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => DisplayList(lista: lista)));
  }

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

        title: Text("Filtro de busquea"),

      ),
      body: 
      Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 140, vertical: 30),
              child: Center(
                child: Image(image: AssetImage('assets/Logo_Acron.png')),
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
                              child: Text("Carro"),
                              onTap: () {
                                searchPriceCar();
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
                              child: Text("Moto"),
                              onTap: () {
                                searchPriceMot();
                              },
                            ),
                          ),
                        ),
                        Divider(color: Colors.black, indent: 19, endIndent: 19),
                      ]
                    )
                  )
                ]
              )
            )
          ]
        ),
      ),
    );
    throw UnimplementedError();
  }
}
