import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mps/models/parkingLots.dart';
import 'package:mps/services/database.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  final Function(List<QueryDocumentSnapshot>) onListUpdated;
  final Function(List<QueryDocumentSnapshot>) onInitList;
  Map(this.onListUpdated, this.onInitList);

  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  List<QueryDocumentSnapshot> lista;
  var txt = TextEditingController();
  GoogleMapController mapController;

  static LatLng _initialPosition = LatLng(0, 0);
  LatLng posPerson;
  String address = "", latitude, longitude, error = "";
  List<Marker> myMarker = [];
  List<Circle> myCircle = [];
  List<Location> locations;

  void _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      addMarker(_initialPosition);
      circles(_initialPosition);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 15.0)));
    });

    parkingLotsInit(position);
  }

  parkingLotsInit(Position position) async {
    _initialPosition = LatLng(position.latitude, position.longitude);
    lista = await getList(_initialPosition);
    change(position.latitude, position.longitude);
    posPerson = _initialPosition;
    setState(() {
      nearParking();
    });
    this.widget.onInitList(lista);
    this.widget.onListUpdated(lista);
    print(lista.length);
  }

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

//Future methods
  Future change(double lat, double long) async {
    List<Placemark> temp = await Queries().addressFromCoordinates(lat, long);
    address = temp.first.street;
    txt.text = address;
    this.widget.onListUpdated(lista);
  }

  Future search(String addr) async {
    locations =
        await Queries().locationFromAddress(addr + ", Bogota, Colombia");
    lista = await getList(
        LatLng(locations.first.latitude, locations.first.longitude));
    nearParking();
    setState(() {
      addMarker(LatLng(locations.first.latitude, locations.first.longitude));
      circles(LatLng(locations.first.latitude, locations.first.longitude));
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(locations.first.latitude, locations.first.longitude),
          zoom: 15.0)));
    });
    posPerson = LatLng(locations.first.latitude, locations.first.longitude);
    this.widget.onListUpdated(lista);
    this.widget.onInitList(lista);
  }

  Future nearParking() async {
    List<Location> loc = [];
    DocumentSnapshot course;
    if (lista.isNotEmpty) {
      for (int i = 0; i < lista.length; i++) {
        course = lista[i];
        loc = [];
        loc =
            await Queries().locationFromAddress(course['direccion'].toString());
        setState(() {
          markers(LatLng(loc.first.latitude, loc.first.longitude), course);
        });
      }
    }
  }

  //update markers when search button is pressed
  Future updateParking(ParkingLots updatedList) async {
    List<Location> loc = [];
    DocumentSnapshot course;
    print((updatedList.list).length);
    if (updatedList.list.isNotEmpty) {
      for (int i = 0; i < updatedList.list.length; i++) {
        course = updatedList.list[i];
        loc = [];
        loc =
            await Queries().locationFromAddress(course['direccion'].toString());
        setState(() {
          markers(LatLng(loc.first.latitude, loc.first.longitude), course);
        });
      }
    }
    updatedList.ranking = false;
    lista = updatedList.list;
    this.widget.onListUpdated(updatedList.list);
  }

  Future getList(LatLng latLng) =>
      (Queries().nearby(latLng.latitude, latLng.longitude));

//The  whole widget that contains the map, ans its buttons
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
    final parkingList = Provider.of<ParkingLots>(context);

    if (parkingList.ranking != null) {
      if (parkingList.ranking == true) {
        addMarker(posPerson);
        updateParking(parkingList);
      }
    }
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
            CameraPosition(target: _initialPosition, zoom: 1),
        onMapCreated: onCreated,
        myLocationEnabled: true,
        markers: Set.from(myMarker),
        circles: Set.from(myCircle),
        scrollGesturesEnabled: true,
        onTap: handle_Tap,
      ),
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
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

  //When user tap screen set the markers
  handle_Tap(LatLng tappedPoint) async {
    change(tappedPoint.latitude, tappedPoint.longitude);
    lista = await getList(tappedPoint);
    nearParking();
    setState(() {
      posPerson = tappedPoint;
      addMarker(tappedPoint);
      circles(tappedPoint);
    });
    this.widget.onInitList(lista);
    this.widget.onListUpdated(lista);
  }

  //set marker for current location or desired location of user (blue marker)
  void addMarker(LatLng latLng) {
    myMarker = [];
    myMarker.add(Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ));
  }

  //Set red markers for nearby parkinglots
  void markers(LatLng latsLongs, DocumentSnapshot place) {
    print(latsLongs);
    myMarker.add(
      Marker(
          markerId: MarkerId(latsLongs.toString()),
          position: latsLongs,
          infoWindow: InfoWindow(
            title: place.data()["nombre"],
            snippet: place.data()["direccion"],
          )),
    );
  }
}
