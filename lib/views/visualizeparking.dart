import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/models/imageCarousel.dart';
import 'package:mps/models/raiting.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/showRoute.dart';

int _rating;
String _coment;
var parking;

class VisualizeParking extends StatefulWidget {
  final String value;
  final DocumentSnapshot parkingLot;
  VisualizeParking(this.value, this.parkingLot);

  @override
  _VisualizeParkingState createState() =>
      _VisualizeParkingState(value, parkingLot);
}

class _VisualizeParkingState extends State<VisualizeParking> {
  String value;
  bool favorite = false;
  DocumentSnapshot parkingLot;
  _VisualizeParkingState(this.value, this.parkingLot);
  var parking;
  List<String> list = [];
  int cont = 0;

  @override
  void initState() {
    parking = Queries().parkingLotById(value);
    for (String i in parkingLot.data()["imagen"]) {
      list.add(i);
    }
    super.initState();
  }

  _likePressed() {
    setState(() {
      favorite = !favorite;
      parking = Queries().parkingLotById(value);
      for (String i in parkingLot.data()["imagen"]) {
        list.add(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Managing Parking System"),
        actions: [
          InkWell(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                            favorite
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: favorite ? Colors.red : Colors.white),
                        onPressed: () => _likePressed()),
                  ],
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: parking,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new CircularProgressIndicator();
                  }
                  parking = snapshot.data;
                  return new Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 50),
                          ),
                          Text(
                            parking["nombre"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black),
                          ),
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 18),
                            ),
                            Icon(Icons.star, size: 35.0, color: Colors.grey),
                            Text(
                              parking["puntaje"].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey),
                            )
                          ]),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30)),
                          Text(
                            "Compartir parqueadero",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Icon(Icons.link)
                        ],
                      ),
                      ImageCarousel(list),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(parking["descripcion"]),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              "Precios: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0)),
                          Text("Carro: "),
                          Text(parking["precio"]["carro"].toString()),
                          Text(" min"),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0)),
                          Text("Moto: "),
                          Text(parking["precio"]["moto"].toString()),
                          Text(" min"),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20)),
                          Text("Direccion: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(parking["direccion"]),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Escriba su comentario aquí",
                                  labelText: "Comentar",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black,
                                  )),
                              onChanged: (val) {
                                _coment = val;
                              },
                            ),
                          ),
                          Text("Puntuar",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Rating((rating) {
                            setState(() {
                              _rating = rating;
                              parking = Queries().parkingLotById(value);
                              for (String i in parkingLot.data()["imagen"]) {
                                list.add(i);
                              } //Esto hace que se refresque el dibujado de la querie de parqueaderos
                            });
                          }),
                          SizedBox(
                              height: 44,
                              child: _rating != null && _rating > 0
                                  ? Text("Has puntuado $_rating ",
                                      style: TextStyle(fontSize: 15))
                                  : SizedBox.shrink()),
                          ElevatedButton(
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue[900]),
                                alignment: Alignment.center),
                            onPressed: () {
                              var comentario = {
                                'comentario': _coment,
                                'estrellas': _rating.toString(),
                                'usuario': ''
                              };
                              modifyComment(value, comentario);
                              parking = Queries().parkingLotById(
                                  value); //Esto hace que se refresque el dibujado de la querie de parqueaderos
                            },
                            child: Text("Publicar"),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            child: Text("Comentarios: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          for (var i in parking["comentarios"])
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            i["usuario"].toString(),
                                          ),
                                          Text(": "),
                                          Icon(Icons.star, color: Colors.grey),
                                          Text(
                                            i["estrellas"].toString(),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        i["comentario"].toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      Text("Seguir ruta:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue[100],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text("Como llegar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    )),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowRoute(
                                            value: parking["direccion"]
                                                .toString())));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
