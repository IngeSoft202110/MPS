import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/userLogSign/selectUser.dart';
import 'package:mps/widgets/sideBar.dart';

import 'mainpageuser.dart';

class HomePartner extends StatefulWidget {
  final List<DocumentSnapshot> lista;
  HomePartner({Key key, @required this.lista}) : super(key: key);
  @override
  _HomePartnerState createState() => _HomePartnerState(lista: lista);
}

class _HomePartnerState extends State<HomePartner> {

  List<QueryDocumentSnapshot> lista = []; 
   _HomePartnerState({this.lista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[900],
        title: Text("HOME"),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SelectUser()),
                    ModalRoute.withName('/'));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPageUser()));
                        }),
                    Icon(Icons.exit_to_app),
                  ],
                )),
          )
        ],
      ),
      drawer: SideBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.symmetric(horizontal: 140, vertical: 30),
              child: Center(
                child: Image(image: AssetImage('assets/Logo_Acron.png')),
              ),
            ),

            Container(
              color: Colors.blue[900],
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              child: Text(
                "Resultados de la búsqueda",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),

            GestureDetector(
              child: new ListView.builder(
                shrinkWrap: true,
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot course = lista[index];
                  return new ListTile(
                    leading: Image.network(course['imagen'][0]),
                    title: Text(course['nombre']),
                    subtitle: Text(course['direccion']),
                    /*onTap: () {
                      value = course.reference.id;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisualizeParking(value: value),
                        ),
                      );
                    },*/
                  );
                },
              ),
            ),

          ],
        ),
      )
      /*body: Container(
        color: Colors.white,
      ),*/
    );
  }
}

// class SideBar extends StatelessWidget {
//   const SideBar({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.indigo[500]),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Image(
//                     image: AssetImage('assets/UserIcon.png'),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text("Perfil"),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: Icon(Icons.local_parking),
//             title: Text("Ver parqueaderos"),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: Icon(Icons.add_location),
//             title: Text("Agregar parqueadero"),
//             onTap: () {
//               //Navigator.push(
//               //MaterialPageRoute(builder: (context) => HomeClient()));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
