import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/addParkingLot.dart';

class SideBar extends StatelessWidget {
  
  const SideBar({
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo[500]),
            child: Column(
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage('assets/UserIcon.png'),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Perfil"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.local_parking),
            title: Text("Ver parqueaderos"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.add_location),
            title: Text("Agregar parqueadero"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddParkingLot()));
            },
          ),
        ],
      ),
    );
  }
}
