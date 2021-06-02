import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mps/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([http.Client])
class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockStream extends Mock implements Stream {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  SharedPreferences.setMockInitialValues({});
  TestWidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  test("parlingLotById", () async {
    Stream<MockDocumentSnapshot> doc;
    //Queries().parkingLotById("28gLeMUXz8faDtstsMrw");
    expect(Queries().parkingLotById("28gLeMUXz8faDtstsMrw"), doc);
  });

  test("nearby", () async {
    List<MockDocumentSnapshot> doc;
    expect(Queries().nearby(4.6287662, -74.0636298647595), doc);
  });

  test("ranking", () async {
    List<MockQueryDocumentSnapshot> doc;
    List<MockQueryDocumentSnapshot> docf;
    expect(Queries().ranking(doc, 3), docf);
  });

  test("priceCar", () async {
    List<MockQueryDocumentSnapshot> doc;
    List<MockQueryDocumentSnapshot> docf;
    expect(Queries().priceCar(doc, 100, 300), docf);
  });

  test("priceMoto", () async {
    List<MockQueryDocumentSnapshot> doc;
    List<MockQueryDocumentSnapshot> docf;
    expect(Queries().pricemMotorcycle(doc, 100, 300), docf);
  });

  test("owner", () async {
    List<MockQueryDocumentSnapshot> doc;
    expect(Queries().owner(), doc);
  });
}
