import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mps/views/favorites.dart';
import 'package:mps/views/history.dart';
import 'package:mps/views/homeClient.dart';
import 'package:mps/services/database.dart';
import '../services/database.dart';
import '../services/database.dart';
import '../services/database.dart';
import '../services/database.dart';
import '../services/database.dart';
import '../services/database.dart';
import '../services/database.dart';
import '../services/database.dart';
import 'homeClient.dart';
import 'userLogSign/formUser.dart';

class MainPageUser extends StatefulWidget {
  @override
  _MainPageUserState createState() => _MainPageUserState();
}

class _MainPageUserState extends State<MainPageUser> {
  String newUsername, newEmail;
  List<DocumentSnapshot> lista = [];
  Key key;

  //User user = AuthMethods().getCurrentUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeClient())),
          ),
          backgroundColor: Colors.blue[900],
          title: Text("User Profile"),
          actions: [
            InkWell(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.favorite),
                          onPressed: () async {
                            List<QueryDocumentSnapshot> favoritos = [];
                            var ids = [];
                            ids = await returningUserFavoriteParkingsLists();
                            favoritos = await snapshotsListFromUser(ids);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FavoritesList(lista: favoritos)));
                          }),
                      IconButton(
                          icon: Icon(Icons.history),
                          onPressed: () async {
                            List<DocumentSnapshot> visitados = [];
                            var ids = [];
                            ids = await returningUserVisitedParkingsLists();
                            visitados = await snapshotsListFromUser(ids);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HistoryList(lista: visitados)));
                          })
                    ],
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
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
                      Text(
                        getNameUser(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        "Email",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      //Aca va el correo del usuario sacado de la base de datos
                      Text(
                        getEmailUser(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue[900]),
                            alignment: Alignment.center),
                        onPressed: () {
                          deleteUser();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormUser()));
                        },
                        child: Text("Delete Account"),
                      ),
                    ],
                  ),
                )),
          ]),
        ));
  }
}
