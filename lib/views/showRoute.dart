import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mps/services/google_maps_requests.dart';
import 'package:uuid/uuid.dart';

class ShowRoute extends StatefulWidget {
  @override
  _ShowRoute createState() => _ShowRoute();
}

class _ShowRoute extends State<ShowRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("Managing Parking System"),
        ),
        body: Map());
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destination = TextEditingController();
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null
        ? Container(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialPosition, zoom: 17),
                onMapCreated: onCreated,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                markers: _markers,
                onCameraMove: _onCameraMove,
                polylines: _polyLines,
              ),

              // Positioned(
              //   top: 105.0,
              //   right: 15.0,
              //   left: 15.0,
              //   child: Container(
              //     height: 50.0,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(3.0),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.grey,
              //             offset: Offset(1.0, 5.0),
              //             blurRadius: 10,
              //             spreadRadius: 3)
              //       ],
              //     ),
              //     child: TextField(
              //       cursorColor: Colors.black,
              //       textInputAction: TextInputAction.go,
              //       onSubmitted: (value) {
              //         sendRequest(value);
              //       },
              //       decoration: InputDecoration(
              //         icon: Container(
              //           margin: EdgeInsets.only(left: 20, top: 5),
              //           width: 10,
              //           height: 10,
              //           child: Icon(
              //             Icons.local_taxi,
              //             color: Colors.black,
              //           ),
              //         ),
              //         hintText: "destination?",
              //         border: InputBorder.none,
              //         contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: 40,
              //   right: 10,
              //   child: FloatingActionButton(
              //     onPressed: _onAddMarkerPressed,
              //     tooltip: "Añadir marcador",
              //     backgroundColor: Colors.black,
              //     child: Icon(
              //       Icons.add_location,
              //       color: Colors.white,
              //     ),
              //   ),
              // )
            ],
          );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _addMarker(LatLng location, String address) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastPosition.toString()),
          position: location,
          infoWindow: InfoWindow(
            title: address,
            snippet: "Destino",
          ),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  void createRoute(String encondedPoly) {
    setState(() {
      print("puntos:");
      print(_convertToLatLng(_decodePoly(encondedPoly)));

      _polyLines.add(Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          width: 2,
          points: _convertToLatLng(_decodePoly(encondedPoly)),
          color: Colors.black));
    });
  }

  //Convert list of doubles into LatLng
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

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
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
      sendRequest("carrera 7 # 45");
    });
  }

  void sendRequest(String intendedLocation) async {
    List<Location> position;

    position =
        await locationFromAddress(intendedLocation + ", Bogota, Colombia");
    //List<Placemark> placemark = await placemarkFromCoordinates(position.first.latitude, position.first.longitude);

    double latitude = position.first.latitude;
    double longitude = position.first.longitude;

    LatLng destination = LatLng(latitude, longitude);
    _addMarker(_initialPosition, intendedLocation);
    _addMarker(destination, intendedLocation);

    print("estoy en: ");
    print(_initialPosition);

    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
  }
}
