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
      //busqueda por Ranking
      Future<List<QueryDocumentSnapshot>> ranking() =>
      FirebaseFirestore.instance.collection('parqueaderos').get()
          
          .then((snapshot) async {
        var docs = snapshot.docs;
        
        
        int j = 0;
        int mayor;
        bool primero = true;
        bool greater = false;

        
        List<QueryDocumentSnapshot> lista = [];
        for (var doc in docs) {         
          
            if(primero){

              lista.add(doc);
              primero = false;

            }else{

              j = 0;
              greater = false;

              for(var doc2 in lista){

                if(doc['puntaje'] > doc2['puntaje'] && !greater){

                  greater = true;
                  mayor = j;

                }

                j++;

              }

              if(greater){

                lista.insert(mayor,doc);

              }

              if(!lista.contains(doc)){
                lista.add(doc);
              }

            }

        }
        return lista;
      });

      //busqueda por Precio

      Future<List<QueryDocumentSnapshot>> priceCar() =>
      FirebaseFirestore.instance.collection('parqueaderos').get()
        .then((snapshot) async {
        var docs = snapshot.docs;
        int j = 0;
        int mayor;
        bool primero = true;
        bool greater = false;
        List<QueryDocumentSnapshot> lista = [];
        for (var doc in docs){
          double.parse(doc['precio.carro']);
          if(primero){
            lista.add(doc);
            primero = false;
          }else{
            j = 0;
            greater = false;
            for(var doc2 in lista){
              if(double.parse(doc['precio.carro']) > double.parse(doc2['precio.carro'])){
                greater = true;
                mayor = j;
                }
                j++;
              }
              if(greater){
                lista.insert(mayor,doc);
              }
              if(!lista.contains(doc)){
                lista.add(doc);
              }
            }
        }
        return lista;
      });

      Future<List<QueryDocumentSnapshot>> pricemMotorcycle() =>
      FirebaseFirestore.instance.collection('parqueaderos').get()
        .then((snapshot) async {
        var docs = snapshot.docs;
        int j = 0;
        int mayor;
        bool primero = true;
        bool greater = false;
        List<QueryDocumentSnapshot> lista = [];
        for (var doc in docs){
          double.parse(doc['precio.moto']);
          if(primero){
            lista.add(doc);
            primero = false;
          }else{
            j = 0;
            greater = false;
            for(var doc2 in lista){
              if(double.parse(doc['precio.moto']) > double.parse(doc2['precio.moto'])){
                greater = true;
                mayor = j;
                }
                j++;
              }
              if(greater){
                lista.insert(mayor,doc);
              }
              if(!lista.contains(doc)){
                lista.add(doc);
              }
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
