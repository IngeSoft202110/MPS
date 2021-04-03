import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class SearchList extends StatefulWidget {
  @override
  _SearchList createState() => _SearchList();
}

class _SearchList extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Managing Parking System"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 140, vertical: 30),
            child: Center(
              child: Image(image: AssetImage('assets/Logo_Acron.png')),
            ),
          ),
          GestureDetector(
            child: Text("Atrás"),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("parqueaderos")
                .snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot course = snapshot.data.docs[index];
                  return ListTile(
                    leading: Image.network(course['imagen']),
                    title: Text(course['nombre']),
                    subtitle: Text(course['direccion']),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
