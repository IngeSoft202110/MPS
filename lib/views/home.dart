import 'package:flutter/material.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/signin.dart';
import 'package:mps/views/searchList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Managing Parking System"),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 140, vertical: 30),
                child: Center(
                  child: Image(image: AssetImage('assets/Logo_Acron.png')),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    "Buscar Parqueadero",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
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
                          Divider(
                              color: Colors.black, indent: 19, endIndent: 19),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: GestureDetector(
                                child: Text("Cercanía"),
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchList()));
                                },
                              ),
                            ),
                          ),
                          Divider(
                              color: Colors.black, indent: 19, endIndent: 19),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Text("Precio"),
                            ),
                          ),
                          Divider(
                              color: Colors.black, indent: 19, endIndent: 19),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              child: Text("Ranking"),
                            ),
                          ),
                          Divider(
                              color: Colors.black, indent: 19, endIndent: 19),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.blue[900],
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                child: Text(
                  "Parqueaderos buscados",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
