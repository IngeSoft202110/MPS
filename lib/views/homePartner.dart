import 'package:flutter/material.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/userLogSign/selectUser.dart';

import 'mainpageuser.dart';

class HomePartner extends StatefulWidget {
  @override
  _HomePartnerState createState() => _HomePartnerState();
}

class _HomePartnerState extends State<HomePartner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
