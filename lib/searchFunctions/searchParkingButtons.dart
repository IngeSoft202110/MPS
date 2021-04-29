import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/views/displayList.dart';
import 'package:mps/views/errorDialog.dart';

class SearchParkingButtons extends StatefulWidget {
  final List<QueryDocumentSnapshot> lista;
  SearchParkingButtons(this.lista);
  @override
  _Buttons createState() => _Buttons(lista);
}

class _Buttons extends State<SearchParkingButtons> {
  List<QueryDocumentSnapshot> lista;
  _Buttons(this.lista);

  @override
  Widget build(BuildContext context) {
    return buttons();
  }

  //Lateral buttons of the map
  Widget buttons() {
    return new Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 30)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: button('assets/Price.png'),
        ),
        button('assets/Ranking.png'),
        Text(lista.length.toString()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: GestureDetector(
            child: button('assets/List.png'),
            onTap: () {
              if (lista.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayList(lista: lista)));
              } else {
                showDialog(
                    context: context,
                    builder: (context) => ErrorDialog(
                        "Error", "No hay parqueaderos en la zona seleccionada"),
                    barrierDismissible: true);
                print("error");
              }
            },
          ),
        ),
      ],
    );
  }

  Widget button(String image) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue[900],
          width: 5,
        ),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
