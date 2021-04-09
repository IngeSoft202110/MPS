import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

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
  Future<List<QueryDocumentSnapshot>> nearby(double latitude, longitud) async {
    List<QueryDocumentSnapshot> lista = [];
    List<Location> coordenadas;

    FirebaseFirestore.instance
        .collection('parqueaderos')
        .get()
        .then((snapshot) async {
      var docs = snapshot.docs;
      for (var doc in docs) {
        coordenadas =
            await locationFromAddress(doc['direccion'] + ", Bogota, Colombia");
        double distanceInMeters = Geolocator.distanceBetween(latitude, longitud,
            coordenadas.first.latitude, coordenadas.first.longitude);

        if (distanceInMeters <= 4000) {
          lista.add(doc);
        }
      }
    });

    return lista;
  }

  //Return all documents in collection
  Stream<QuerySnapshot> allDocuments() {
    var temp =
        FirebaseFirestore.instance.collection('parqueaderos').snapshots();
    return temp;
  }
}
