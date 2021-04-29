import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mps/services/database.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

class Map extends StatefulWidget {
  final Function(List<QueryDocumentSnapshot>) onListUpdated;
  Map(this.onListUpdated);

  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  List<QueryDocumentSnapshot> lista;
  var txt = TextEditingController();
  GoogleMapsController controller;

  static const _initialPosition = LatLng(4.6097100, -74.0817500);
  String address = "", latitude, longitude, error = "";
  List<Marker> myMarker = [];
  List<Circle> myCircle = [];
  List<Location> locations;

  @override
  void initState() {
    addMarker(_initialPosition);
    circles(_initialPosition);
    controller = GoogleMapsController(
      initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 15),
    );
    super.initState();
  }

//Future methods
  Future change(double lat, double long) async {
    List<Placemark> temp = await Queries().addressFromCoordinates(lat, long);
    address = temp.first.street;
    txt.text = address;
  }

  Future search(String addr) async {
    locations =
        await Queries().locationFromAddress(addr + ", Bogota, Colombia");
    lista = await getList(
        LatLng(locations.first.latitude, locations.first.longitude));
    nearParking(LatLng(locations.first.latitude, locations.first.longitude));
    setState(() {
      addMarker(LatLng(locations.first.latitude, locations.first.longitude));
      circles(LatLng(locations.first.latitude, locations.first.longitude));
      controller.zoomTo(50);
    });
    this.widget.onListUpdated(lista);
  }

  Future nearParking(LatLng latLng) async {
    List<Location> loc = [];
    DocumentSnapshot course;
    if (lista.isNotEmpty) {
      for (int i = 0; i < lista.length; i++) {
        course = lista[i];
        loc = [];
        loc =
            await Queries().locationFromAddress(course['direccion'].toString());
        setState(() {
          markers(LatLng(loc.first.latitude, loc.first.longitude));
        });
      }
    }
  }

  Future getList(LatLng latLng) =>
      (Queries().nearby(latLng.latitude, latLng.longitude));

//Te  whole widget that contains the map, ans its buttons
//
  Widget buildBody() {
    return new Column(
      children: [
        buildAddressBar(),
        googleMapView(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

//The map
  Widget googleMapView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 150,
      child: GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        initialCameraPosition:
            CameraPosition(target: _initialPosition, zoom: 15),
        markers: Set.from(myMarker),
        circles: Set.from(myCircle),
        scrollGesturesEnabled: true,
        onTap: handle_Tap,
      ),
    );
  }

//Search bar for wirting directions
  Widget buildAddressBar() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Dirección destino'),
            controller: txt,
            onChanged: (val) {
              address = val;
            },
          ),
        ),
        new GestureDetector(
          onTap: () {
            if (address != null) {
              search(address);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.search),
          ),
        )
      ],
    );
  }

//Handle tap markers and circle
//Radius of search
  void circles(LatLng latlong) {
    myCircle = [];
    myCircle.add(
      Circle(
          circleId: CircleId(
            "ID:" + DateTime.now().millisecondsSinceEpoch.toString(),
          ),
          center: latlong,
          fillColor: Color.fromRGBO(0, 180, 255, 210),
          strokeColor: Color.fromRGBO(0, 100, 255, 100),
          strokeWidth: 2,
          radius: 1000),
    );
  }

  handle_Tap(LatLng tappedPoint) async {
    change(tappedPoint.latitude, tappedPoint.longitude);
    lista = await getList(tappedPoint);
    nearParking(tappedPoint);
    setState(() {
      addMarker(tappedPoint);
      circles(tappedPoint);
    });
    this.widget.onListUpdated(lista);
  }

  void addMarker(LatLng latLng) {
    myMarker = [];
    myMarker.add(Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ));
  }

  void markers(LatLng latsLongs) {
    print(latsLongs);
    myMarker.add(
      Marker(
        markerId: MarkerId(latsLongs.toString()),
        position: latsLongs,
      ),
    );
  }
}
