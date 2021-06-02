// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'package:mps/main.dart';
import 'package:mps/searchFunctions/searchParkingButtons.dart';
import 'package:mps/views/addParkingLot.dart';
import 'package:mps/views/errorDialog.dart';
import 'package:mps/views/userLogSign/formUser.dart';
import 'package:mps/views/userLogSign/signin.dart';
import 'package:mps/views/visualizeparking.dart';
import 'package:mps/widgets/sideBar.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  testWidgets('Add parkinglot: TextField avaible', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddParkingLot()));
    var textField = find.byType(TextFormField);
    expect(textField, findsWidgets);
  });

  testWidgets('Add parkinglot: Add Button avaible',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddParkingLot()));
    var button = find.text("Añadir parqueadero");
    expect(button, findsOneWidget);
  });

  testWidgets('Error Dialog: Funtioning dialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ErrorDialog("Error", "Dialog")));
    final titleFinder = find.text("Error");
    final messageFinder = find.text("Dialog");
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });

  testWidgets('SideBar: ExistSidebar partner', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SideBar()));

    //Ver parqueaderos
    final titleFinder = find.text("Ver parqueaderos");
    expect(titleFinder, findsOneWidget);

    //Perfil
    final perfil = find.text("Perfil");
    expect(perfil, findsOneWidget);

    //Añadir parqueaderos
    final addParking = find.text("Agregar parqueadero");
    expect(addParking, findsOneWidget);

    //Icons location
    final icono = find.byIcon(Icons.add_location);
    expect(icono, findsOneWidget);

    //Icons parking
    final iconoParking = find.byIcon(Icons.local_parking);
    expect(iconoParking, findsOneWidget);

    //Icon to fail
    final iconoFail = find.byIcon(Icons.backpack);
    expect(iconoFail, findsNothing);
  });

  testWidgets('Buttons enabeled: SearchParkingButtons',
      (WidgetTester tester) async {
    List<MockQueryDocumentSnapshot> doc;
    await tester.pumpWidget(MaterialApp(home: SearchParkingButtons(doc)));
    final titleFinder = find.byWidget(button("image"));
    expect(titleFinder, findsNothing);
  });
}
