import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/models/parkingLots.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/errorDialog.dart';
import 'package:provider/provider.dart';

class PriceDialog extends StatefulWidget {
  @override
  _PriceDialog createState() => _PriceDialog();
}

class _PriceDialog extends State<PriceDialog> {
  int _value;
  List<QueryDocumentSnapshot> update;
  double minprice = 10;
  double maxprice = 500;
  RangeValues _currentRangeValues = RangeValues(10, 500);
  RangeLabels labels = RangeLabels('10', "500");

  @override
  Widget build(BuildContext context) {
    final parkingList = Provider.of<ParkingLots>(context);

    return new BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        title: new Row(
          children: [
            Container(
                height: 60, width: 60, child: Image.asset('assets/Price.png')),
            Expanded(
                child: Text("Seleccione precio y tipo de vehículo",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue[900]))),
          ],
        ),
        content: content(),
        actions: [
          GestureDetector(
            onTap: () {
              if (_value != null) {
                if (_value == 1) {
                  setState(() {
                    update = [];
                    double lInferior = _currentRangeValues.start;
                    double lSuperior = _currentRangeValues.end;
                    update = Queries().pricemMotorcycle(
                        parkingList.list, lInferior, lSuperior);
                  });
                } else if (_value == 2) {
                  setState(() {
                    update = [];
                    double lInferior = _currentRangeValues.start;
                    double lSuperior = _currentRangeValues.end;
                    update = Queries()
                        .priceCar(parkingList.list, lInferior, lSuperior);
                  });
                }
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
                        ErrorDialog("Error", "Seleccione precio y/o tipo"),
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

  Widget content() {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton(
            hint: Text("Tipo de vehículo"),
            value: _value,
            items: [
              DropdownMenuItem(
                child: Text("Moto"),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text("Carro"),
                value: 2,
              ),
            ],
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            }),
        Row(
          children: [
            Text(minprice.toString()),
            Expanded(
              child: RangeSlider(
                min: minprice,
                max: maxprice,
                values: _currentRangeValues,
                divisions: 9,
                labels: labels,
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                    labels = RangeLabels(
                        "${_currentRangeValues.start.toInt().toString()}\$",
                        "${_currentRangeValues.end.toInt().toString()}\$");
                  });
                },
              ),
            ),
            Text(maxprice.toString()),
          ],
        )
      ],
    );
  }
}
