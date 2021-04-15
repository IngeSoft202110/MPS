import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:geolocator/geolocator.dart';

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
          if (distanceInMeters <= 4000) {
            lista.add(doc);
          }
        }
        return lista;
      });

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
