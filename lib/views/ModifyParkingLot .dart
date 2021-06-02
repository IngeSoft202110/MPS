//import 'dart:js_util';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mps/services/database.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mps/models/parkingLot.dart';
import 'package:mps/widgets/buttonWidget.dart';
import 'package:mps/widgets/sideBar.dart';

import 'homePartner.dart';

class ModifyParkingLot extends StatefulWidget {
  final String value;
  ModifyParkingLot(this.value);
  @override
  _ModifyParkingLotState createState() => _ModifyParkingLotState(value);
}

class _ModifyParkingLotState extends State<ModifyParkingLot> {
  String value;
  File file;
  
  String priceCar, priceBike, nombre, direccion, descripcion;
  //int score;
  List images = [];
  final _formKey = GlobalKey<FormState>();

  _ModifyParkingLotState(this.value);

  var parking;

  @override
  void initState() {

    parking = Queries().parkingLotById(value);

    super.initState();
  
  }
  getNombre(BuildContext context) async {
    FirebaseFirestore.instance.collection('parqueaderos').doc(value).update({
          "nombre": nombre
        });
  }

  getDireccion(BuildContext context) async {
    FirebaseFirestore.instance.collection('parqueaderos').doc(value).update({
          "direccion": direccion
        });
  }

  getDescripcion(BuildContext context) async {
    FirebaseFirestore.instance.collection('parqueaderos').doc(value).update({
          "descripcion": descripcion
        });
  }

  addParking(BuildContext context) async {
    

        Map<String, dynamic> price = {"carro": priceCar, "moto": priceBike};
        
        ///DocumentSnapshot d = FirebaseFirestore.instance.collection('parqueaderos').doc(value).get() as DocumentSnapshot;
        
        /*if(nombre == null){
          nombre = d['nombre'].toString();
          print(nombre);
        }        

        if(direccion == null){
          direccion = d['direccion'].toString();
          print(direccion);
        }*/
        
        
        FirebaseFirestore.instance.collection('parqueaderos').doc(value).update({
          "precio": price,
          //"nombre": nombre,
          //"direccion": direccion,
          //"descripcion": descripcion
        });
        
  }

  @override
  Widget build(BuildContext context) {
    final filename =
        file != null ? basename(file.path) : 'Archivo no seleccionado';

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[900],
        title: Text("Modificar Parqueadero"),
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
                  /*validator: (val) {
                    return val.isEmpty ? "Ingrese nombre" : null;
                  },*/
                  decoration: InputDecoration(hintText: "Nombre"),
                  onChanged: (val) {
                    nombre = val;
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    getNombre(context);
                    /*List<QueryDocumentSnapshot> lista = []; 
                                lista = await Queries().owner();
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomePartner(lista:lista)));*/
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Cambiar",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  /*validator: (val) {
                    return val.isEmpty ? "Ingrese la dirección" : null;
                  },*/
                  
                  decoration: InputDecoration(hintText: "Direccion"),
                  onChanged: (val) {
                    direccion = val;
                    
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    getDireccion(context);
                    /*List<QueryDocumentSnapshot> lista = []; 
                                lista = await Queries().owner();
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomePartner(lista:lista)));*/
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Cambiar",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  /*validator: (val) {
                    return val.isEmpty ? "Ingrese la descripción" : null;
                  },*/
                  decoration: InputDecoration(hintText: "Descripcion"),
                  onChanged: (val) {
                    descripcion = val;
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    getDescripcion(context);
                    /*List<QueryDocumentSnapshot> lista = []; 
                                lista = await Queries().owner();
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomePartner(lista:lista)));*/
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Cambiar",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                /*ButtonWidget(
                  text: 'Select file',
                  icon: Icons.attach_file,
                  onClicked: selectFile,
                ),
                Text(filename),*/
                /*TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Ingrese la puntuación" : null;
                  },
                  decoration: InputDecoration(hintText: "Score"),
                  onChanged: (val) {
                    score = int.parse(val);
                  },
                ),*/
                TextFormField(
                  /*validator: (val) {
                    return val.isEmpty
                        ? "Ingrese el precio para automóvil"
                        : null;
                  },*/
                  decoration: InputDecoration(hintText: "Price Car"),
                  onChanged: (val) {
                    priceCar = val;
                  },
                ),
                TextFormField(
                  /*validator: (val) {
                    return val.isEmpty
                        ? "Ingrese el precio para motocicleta"
                        : null;
                  },*/
                  decoration: InputDecoration(hintText: "Price Motorbike"),
                  onChanged: (val) {
                    priceBike = val;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () async {
                    addParking(context);
                    List<QueryDocumentSnapshot> lista = []; 
                                lista = await Queries().owner();
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomePartner(lista:lista)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigo[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Cambiar",
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
