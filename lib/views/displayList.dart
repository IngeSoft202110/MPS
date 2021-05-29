import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/views/visualizeparking.dart';

//Class to show list of parkings
class DisplayList extends StatefulWidget {
  final List<DocumentSnapshot> lista;
  DisplayList({Key key, @required this.lista}) : super(key: key);
  @override
  _DisplayList createState() => _DisplayList(lista: lista);
}

class _DisplayList extends State<DisplayList> {
  String value;
  List<DocumentSnapshot> lista;
  _DisplayList({this.lista});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Managing Parking System"),
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: [
            Container(
              color: Colors.blue[900],
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              child: Text(
                "Resultados de la búsqueda",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            new GestureDetector(
              child: new ListView.builder(
                shrinkWrap: true,
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot course = lista[index];
                  return new ListTile(
                    leading: Image.network(course['imagen'][0]),
                    title: Text(course['nombre']),
                    subtitle: Text(course['direccion']),
                    onTap: () {
                      value = course.reference.id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisualizeParking(value, course),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
