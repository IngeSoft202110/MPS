import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mps/models/parkingLots.dart';
import 'package:provider/provider.dart';

class PriceDialog extends StatefulWidget {
  @override
  _PriceDialog createState() => _PriceDialog();
}

class _PriceDialog extends State<PriceDialog> {
  int _value;
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
              //Navigator.of(context).pop();
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
