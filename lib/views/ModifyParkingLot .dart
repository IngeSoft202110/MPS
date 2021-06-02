//import 'dart:js_util';

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mps/services/database.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mps/models/parkingLot.dart';
import 'package:mps/widgets/buttonWidget.dart';
import 'package:mps/widgets/sideBar.dart';

class ModifyParkingLot extends StatefulWidget {
  @override
  _ModifyParkingLotState createState() => _ModifyParkingLotState();
}

class _ModifyParkingLotState extends State<ModifyParkingLot> {
  File file;
  ParkingLot parking = new ParkingLot();
  String priceCar, priceBike;
  int score;
  List images = [];
  final _formKey = GlobalKey<FormState>();

  addParking(BuildContext context) async {
    if (_formKey.currentState.validate() && file != null) {
      final filename = basename(file.path);
      final destination = 'Images/$filename';
      UploadTask url;

      url = FirebaseUpload.uploadFile(destination, file);
      if (url != null) {
        final snapshot = await url.whenComplete(() {});
        final urlImage = await snapshot.ref.getDownloadURL();
        images.add(urlImage);
        var comentario = {'comentario': "", 'estrellas': "", 'usuario': ''};
        List comments = [];
        comments.add(comentario);

        Map<String, dynamic> price = {"carro": priceCar, "moto": priceBike};
        Map<String, dynamic> data = {
          "nombre": parking.getName(),
          "direccion": parking.getAddress(),
          "descripcion": parking.getDescription(),
          "comentarios": comments,
          "imagen": images,
          "puntaje": score.toString(),
          "precio": price,
          "dueno": getNameUser()
        };
        if (uploadParkingLot(data) != null) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Parqueadero agregado correctamente"),
                  ),
              barrierDismissible: true);
          _formKey.currentState.reset();
          // showDialog(
          //   context: context,
          //   builder: (_) => new CupertinoAlertDialog(
          //     title: new Text("Registro realizado"),
          //     content: new Text("Se ha registrado el parqueadero correctamente"),
          //     actions: <Widget>[
          //       TextButton(
          //         child: Text('Close me!'),
          //         onPressed: () {
          //           Navigator.of(context).pop();
          //         },
          //       )
          //     ],
          //   ),
          // );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filename =
        file != null ? basename(file.path) : 'Archivo no seleccionado';

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[900],
        title: Text("Add Parkinglot"),
      ),
      drawer: SideBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Ingrese nombre" : null;
                  },
                  decoration: InputDecoration(hintText: "Name"),
                  onChanged: (val) {
                    parking.setName(val);
                  },
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Ingrese la dirección" : null;
                  },
                  decoration: InputDecoration(hintText: "Address"),
                  onChanged: (val) {
                    parking.setAddress(val);
                  },
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Ingrese la descripción" : null;
                  },
                  decoration: InputDecoration(hintText: "Description"),
                  onChanged: (val) {
                    parking.setDescription(val);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonWidget(
                  text: 'Select file',
                  icon: Icons.attach_file,
                  onClicked: selectFile,
                ),
                Text(filename),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Ingrese la puntuación" : null;
                  },
                  decoration: InputDecoration(hintText: "Score"),
                  onChanged: (val) {
                    score = int.parse(val);
                  },
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty
                        ? "Ingrese el precio para automóvil"
                        : null;
                  },
                  decoration: InputDecoration(hintText: "Price Car"),
                  onChanged: (val) {
                    priceCar = val;
                  },
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty
                        ? "Ingrese el precio para motocicleta"
                        : null;
                  },
                  decoration: InputDecoration(hintText: "Price Motorbike"),
                  onChanged: (val) {
                    priceBike = val;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    addParking(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Añadir parqueadero",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    final path = result.files.single.path;

    setState(() {
      file = File(path);
    });
  }
}
