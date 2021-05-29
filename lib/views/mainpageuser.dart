import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mps/views/homeClient.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/errorDialog.dart';
import '../services/database.dart';
import '../services/database.dart';
import '../services/database.dart';
import '../services/database.dart';

class MainPageUser extends StatefulWidget {
  @override
  _MainPageUserState createState() => _MainPageUserState();
}

class _MainPageUserState extends State<MainPageUser> {
  String newUsername, newEmail;
  final _newUsernameCon = new TextEditingController();
  final _newEmailCon = new TextEditingController();
  //User user = AuthMethods().getCurrentUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeClient())),
        ),
        backgroundColor: Colors.blue[900],
        title: Text("User Profile"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 130, vertical: 0),
                child: Column(children: [
                  Image(image: AssetImage(getPhotoURLUSer())),
                ])),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: [
                  Text(
                    "Username",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  //Aca va el username del usuario sacado de la base de datos
                  TextField(
                      controller: _newUsernameCon,
                      decoration: InputDecoration(
                        hintText: "Escriiba su nuevo nombre de usuario",
                        labelText: getNameUser(),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                  //Aca va el correo del usuario sacado de la base de datos
                  TextField(
                      controller: _newEmailCon,
                      decoration: InputDecoration(
                        hintText: "Escriiba su nuevo correo electrónico",
                        labelText: getEmailUser(),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                  //Aca va el boton para actualizar los datos del usuario
                  ElevatedButton(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[900]),
                        alignment: Alignment.center),
                    onPressed: () {
                      setState(() {
                        newUsername = _newUsernameCon.text;
                        newEmail = _newEmailCon.text;
                        if (newUsername != null || newUsername == "") {
                          setEmailUser(newUsername);
                        }
                        if (newEmail != null || newEmail == "") {
                          try {
                            setEmailUser(newEmail);
                          } on PlatformException catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    ErrorDialog("Error", "Email no válido"));
                          }
                        }
                      });
                    },
                    child: Text("Actualizar Datos"),
                  ),
                  Text("New Username: $newUsername \n New Email: $newEmail")
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
