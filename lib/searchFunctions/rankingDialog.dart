import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mps/models/parkingLots.dart';
import 'package:mps/models/raiting.dart';
import 'package:provider/provider.dart';

class RankingDialog extends StatefulWidget {
  @override
  _RankingDialog createState() => _RankingDialog();
}

class _RankingDialog extends State<RankingDialog> {
  int _rating;
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
            //Esto hace que se refresque el dibujado de la querie de parqueaderos
          });
        }),
        actions: [
          GestureDetector(
            onTap: () {
              //hace la busqueda por ranking
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
