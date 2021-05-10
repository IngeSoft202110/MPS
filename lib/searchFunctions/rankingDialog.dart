import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/models/parkingLots.dart';
import 'package:mps/models/raiting.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/errorDialog.dart';
import 'package:provider/provider.dart';

class RankingDialog extends StatefulWidget {
  @override
  _RankingDialog createState() => _RankingDialog();
}

class _RankingDialog extends State<RankingDialog> {
  int _rating;
  List<QueryDocumentSnapshot> update = [];
  @override
  Widget build(BuildContext context) {
    final parkingList = Provider.of<ParkingLots>(context);

    return new BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: new Row(
          children: [
            Container(
                height: 60,
                width: 60,
                child: Image.asset('assets/Ranking.png')),
            Expanded(
                child: Text("Seleccione calificación del parqueadero",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]))),
          ],
        ),
        content: Rating((rating) {
          setState(() {
            _rating = rating;
          });
        }),
        actions: [
          GestureDetector(
            onTap: () {
              if (_rating != null) {
                setState(() {
                  update = [];
                  update = Queries().ranking(parkingList.list, _rating);
                });
                if (update.isNotEmpty) {
                  parkingList.list = update;
                  parkingList.ranking = true;
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => ErrorDialog("Error",
                          "No hay parqueaderos con esas características"),
                      barrierDismissible: true);
                }
              }
              //hace la busqueda por ranking
              else {
                showDialog(
                    context: context,
                    builder: (context) =>
                        ErrorDialog("Error", "Seleccione ranking"),
                    barrierDismissible: true);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blue[100],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Buscar"),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blue[100],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Cancelar"),
            ),
          ),
        ],
      ),
    );
  }
}
