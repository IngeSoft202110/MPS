import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mps/views/displayList.dart';
import 'package:mps/services/database.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:mps/views/home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  var txt = TextEditingController();
  String address = "", latitude, longitude, error = "";
  static const _initialPosition = LatLng(4.6097100, -74.0817500);
  List<Marker> myMarker = [];

  @override
  void initState() {
    allDocuments = Queries().allDocuments();
    txt.text = address;
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

  Future change(double lat, double long) async {
    List<Placemark> temp = await Queries().addressFromCoordinates(lat, long);
    setState(() {
      address = temp.first.street;
    });
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
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Dirección destino'),
                controller: txt,
                onChanged: (val) {
                  address = val;
                },
                onTap: () {
                  error = "";
                },
              ),
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
              SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // or use fixed size like 200
                  height: MediaQuery.of(context).size.height / 2,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition:
                        CameraPosition(target: _initialPosition, zoom: 11),
                    markers: Set.from(myMarker),
                    onTap: handle_Tap,
                  ))
            ],
          ),
        ));
  }

  handle_Tap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()), position: tappedPoint));
      change(tappedPoint.latitude, tappedPoint.longitude);
      txt.text = address;
      error = "";
    });
  }
}
