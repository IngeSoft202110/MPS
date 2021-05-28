import 'package:flutter/material.dart';

class AddParkingLot extends StatefulWidget {
  @override
  _AddParkingLotState createState() => _AddParkingLotState();
}

class _AddParkingLotState extends State<AddParkingLot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[900],
        title: Text("Add Parkinglot"),
      ),
    );
  }
}
