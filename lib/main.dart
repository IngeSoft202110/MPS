import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mps/models/parkingLots.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/homeClient.dart';
import 'package:mps/views/userLogSign/selectUser.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ParkingLots(),
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: FutureBuilder(
              future: AuthMethods().getCurrentUser(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return HomeClient();
                } else {
                  return SelectUser();
                }
              })),
    );
  }
}
