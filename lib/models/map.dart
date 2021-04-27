import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mps/services/database.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';

class Map extends StatefulWidget {
  final Function(int) callMap;
  Map(this.callMap);
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  var txt = TextEditingController();
  static const _initialPosition = LatLng(4.6097100, -74.0817500);
  String address = "", latitude, longitude, error = "";
  List<Marker> myMarker = [];
  List<Location> locations;

  Future change(double lat, double long) async {
    List<Placemark> temp = await Queries().addressFromCoordinates(lat, long);
    address = temp.first.street;
    txt.text = address;
  }

  @override
  void initState() {
    myMarker.add(Marker(
        markerId: MarkerId("punto"),
        position: (LatLng(4.6097100, -74.0817500))));
    super.initState();
  }

  Future search(String addr) async {
    locations =
        await Queries().locationFromAddress(addr + ", Bogota, Colombia");
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId("punto"),
          position:
              (LatLng(locations.first.latitude, locations.first.longitude))));
    });
  }

  Widget buildBody() {
    return new Column(
      children: [
        buildAddressBar(),
        Stack(children: [googleMapView(), buttons()])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget googleMapView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 150,
      child: GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        onCameraMove: (CameraPosition cameraPosition) {
          print(cameraPosition.zoom);
        },
        initialCameraPosition:
            CameraPosition(target: _initialPosition, zoom: 11),
        markers: Set.from(myMarker),
        scrollGesturesEnabled: true,
        onTap: handle_Tap,
      ),
    );
  }

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
            onTap: () {
              error = "";
            },
          ),
        ),
        new GestureDetector(
          onTap: () {
            if (address != null) {
              search(address);
            } else {
              setState(() {
                error = "Escriba una dircción";
              });
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

  handle_Tap(LatLng tappedPoint) {
    change(tappedPoint.latitude, tappedPoint.longitude);
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()), position: tappedPoint));
      error = "";
    });
  }

  Widget buttons() {
    return new Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: button('assets/Price.png'),
        ),
        button('assets/Ranking.png'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: button('assets/List.png'),
        )
      ],
    );
  }

  Widget button(String image) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue[900],
          width: 5,
        ),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
