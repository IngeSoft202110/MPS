import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/models/raiting.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/showRoute.dart';

int _rating;
String _coment;
var parking;

class VisualizeParking extends StatefulWidget {
  final String value;
  VisualizeParking({Key key, @required this.value}) : super(key: key);

  @override
  _VisualizeParkingState createState() => _VisualizeParkingState(value: value);
}

class _VisualizeParkingState extends State<VisualizeParking> {
  String value;
  _VisualizeParkingState({this.value});
  var parking;
  DocumentSnapshot parkingLot;

  @override
  void initState() {
    parking = Queries().parkingLotById(value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                                horizontal: 20, vertical: 18),
                          ),
                          Text(
                            parking["nombre"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
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
                      Image.network(parking["imagen"], width: 350),
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
                              parking = Queries().parkingLotById(
                                  value); //Esto hace que se refresque el dibujado de la querie de parqueaderos
                            });
                          }),
                          SizedBox(
                              height: 44,
                              child: _rating != null && _rating > 0
                                  ? Text("Has puntuado $_rating ",
                                      style: TextStyle(fontSize: 15))
                                  : SizedBox.shrink()),
                          TextButton(
                              child: Text("Publicar",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              onPressed: () {
                                var comentario = {
                                  'comentario': _coment,
                                  'estrellas': _rating.toString(),
                                  'usuario': ''
                                };
                                modifyComment(value, comentario);
                                parking = Queries().parkingLotById(
                                    value); //Esto hace que se refresque el dibujado de la querie de parqueaderos
                              }),
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
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 0),
                            child: GestureDetector(
                              child: Text("Como llegar: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              onTap: () {
                                Navigator.pushReplacement(
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
