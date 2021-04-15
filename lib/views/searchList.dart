import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mps/views/displayList.dart';
import 'package:mps/services/database.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:mps/views/home.dart';

//Search parking lot nearby
class SearchList extends StatefulWidget {
  @override
  _SearchList createState() => _SearchList();
}

//Search...
class _SearchList extends State<SearchList> {
  List<QueryDocumentSnapshot> lista;
  Stream<QuerySnapshot> allDocuments;
  List<Location> locations;
  String address, latitude, longitude, error = "____";

  @override
  void initState() {
    allDocuments = Queries().allDocuments();
    super.initState();
  }

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
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 140, vertical: 30),
                child: Center(
                  child: Image(image: AssetImage('assets/Logo_Acron.png')),
                ),
              ),
              Text("Buscar por cercanía",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              //Spacer(),
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Dirección destino'),
                onChanged: (val) {
                  address = val;
                },
              ),
              //Spacer(),
              new GestureDetector(
                onTap: () {
                  if (address != null) {
                    search(address);
                  } else {
                    setState(() {
                      error = "Escriba una dircción";
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Buscar",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Text(error),

              //Spacer(),
            ],
          ),
        ));
  }
}
