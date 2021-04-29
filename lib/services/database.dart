import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';

////////******************////////////////*** */ */
///Registros

class DatabaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
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
  Future<List<QueryDocumentSnapshot>> ranking() => FirebaseFirestore.instance
          .collection('parqueaderos')
          .get()
          .then((snapshot) async {
        var docs = snapshot.docs;
        List<QueryDocumentSnapshot> lista = [];
        lista.addAll(docs.where((element) => double.parse(element['puntaje']) < 5.1));

        return lista;
      });

  //busqueda por Precio

  Future<List<QueryDocumentSnapshot>> priceCar() => FirebaseFirestore.instance
          .collection('parqueaderos')
          .get()
          .then((snapshot) async {
        var docs = snapshot.docs;
        List<QueryDocumentSnapshot> lista = [];
        lista.addAll(docs.where((element) => double.parse(element['precio.carro']) > 5.1));
        /*
        var docs3 = snapshot.docs;
        print("Comenzamos la jugadaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        docs3.forEach((element) {print(element['puntaje']);});
        var trynew = docs3.where((element) => double.parse(element['puntaje']) < 5.1);
        trynew.forEach((element) {print(element['puntaje']);});
        int j = 0;
        int menor;
        bool primero = true;
        bool greater = false;
        List<QueryDocumentSnapshot> lista = [];
        for (var doc in docs) {
          double.parse(doc['precio.carro']);
          if (primero) {
            lista.add(doc);
            primero = false;
          } else {
            j = 0;
            greater = false;
            for (var doc2 in lista) {
              if (double.parse(doc['precio.carro']) <
                  double.parse(doc2['precio.carro'])) {
                greater = true;
                menor = j;
              }
              j++;
            }
            if (greater) {
              lista.insert(menor, doc);
            }
            if (!lista.contains(doc)) {
              lista.add(doc);
            }
          }
        }*/
        return lista;
      });

  Future<List<QueryDocumentSnapshot>> pricemMotorcycle() =>
      FirebaseFirestore.instance
          .collection('parqueaderos')
          .get()
          .then((snapshot) async {
        var docs = snapshot.docs;
        List<QueryDocumentSnapshot> lista = [];
        lista.addAll(docs.where((element) => double.parse(element['precio.moto']) > 5.1));
        /*int j = 0;
        int menor;
        bool primero = true;
        bool greater = false;
        List<QueryDocumentSnapshot> lista = [];
        for (var doc in docs) {
          double.parse(doc['precio.moto']);
          if (primero) {
            lista.add(doc);
            primero = false;
          } else {
            j = 0;
            greater = false;
            for (var doc2 in lista) {
              if (double.parse(doc['precio.moto']) <
                  double.parse(doc2['precio.moto'])) {
                greater = true;
                menor = j;
              }
              j++;
            }
            if (greater) {
              lista.insert(menor, doc);
            }
            if (!lista.contains(doc)) {
              lista.add(doc);
            }
          }
        }*/
        return lista;
      });

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
