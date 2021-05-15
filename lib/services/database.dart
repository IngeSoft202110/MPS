import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';

////////******************////////////////*** */ */
///Registros

class DatabaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap, String typeUser) async {
    //if (typeUser == 'cliente') {
    FirebaseFirestore.instance.collection("users").doc(userId).set(userInfoMap);
    //} else {
    FirebaseFirestore.instance
        .collection("owners")
        .doc(userId)
        .set(userInfoMap);
    //}
  }
}

////////******************////////////////*** */ */
///Consultas
class Queries {
  //Transform given adress into coordinates
  Future<List<Location>> locationFromAddress(
    String address, {
    String localeIdentifier = "es-CO",
  }) =>
      GeocodingPlatform.instance.locationFromAddress(
        address,
        localeIdentifier: localeIdentifier,
      );

  //Transform coordinates into address
  Future<List<Placemark>> addressFromCoordinates(double lat, double long) =>
      placemarkFromCoordinates(lat, long);

  //Nearby places
  Future<List<QueryDocumentSnapshot>> nearby(
          double latitude, double longitud) =>
      FirebaseFirestore.instance.collection('parqueaderos').get()
          // ignore: missing_return
          .then((snapshot) async {
        var docs = snapshot.docs;
        List<QueryDocumentSnapshot> lista = [];
        for (var doc in docs) {
          List<Location> coordenadas;

          coordenadas = await locationFromAddress(
              doc['direccion'] + ", Bogota, Colombia");
          double distanceInMeters = Geolocator.distanceBetween(
              latitude,
              longitud,
              coordenadas.first.latitude,
              coordenadas.first.longitude);
          print(distanceInMeters);
          if (distanceInMeters <= 1000) {
            lista.add(doc);
          }
        }
        return lista;
      });
  //busqueda por Ranking
  List<QueryDocumentSnapshot> ranking(
      List<QueryDocumentSnapshot> lista, int puntaje) {
    List<QueryDocumentSnapshot> li = [];
    li.addAll(
        lista.where((element) => (int.parse(element['puntaje'])) == puntaje));

    return li;
  }
  //busqueda por Precio

  List<QueryDocumentSnapshot> priceCar(
      List<QueryDocumentSnapshot> lista, double lInferior, double lSuperior) {
    List<QueryDocumentSnapshot> li = [];
    li.addAll(lista
        .where((element) => double.parse(element['precio.carro']) > lInferior)
        .where((element) => double.parse(element['precio.carro']) < lSuperior));

    return li;
  }

  List<QueryDocumentSnapshot> pricemMotorcycle(
      List<QueryDocumentSnapshot> lista, double lInferior, double lSuperior) {
    List<QueryDocumentSnapshot> li = [];
    li.addAll(lista
        .where((element) => double.parse(element['precio.moto']) > lInferior)
        .where((element) => double.parse(element['precio.moto']) < lSuperior));

    return li;
  }

  //search by Ranking
  //buenas

  //Return all documents in collection
  Stream<QuerySnapshot> allDocuments() {
    var temp =
        FirebaseFirestore.instance.collection('parqueaderos').snapshots();
    return temp;
  }

  //Return specific parking by id
  Stream<DocumentSnapshot> parkingLotById(String id) =>
      FirebaseFirestore.instance.collection("parqueaderos").doc(id).snapshots();
}

void modifyComment(String value, Map data) async {
  final snapShot = await FirebaseFirestore.instance
      .collection('parqueaderos')
      .doc(value)
      .get();
  data.update('usuario', (value) => getNameUser());

  List comentarios = snapShot['comentarios'];
  comentarios.add(data);
  print(comentarios);

  final newData = await FirebaseFirestore.instance
      .collection('parqueaderos')
      .doc(value)
      .update({"comentarios": FieldValue.arrayUnion(comentarios)});
}

String getNameUser() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userName = auth.currentUser.email.replaceAll("@gmail.com", "");
  print(userName);
  return userName;
}
