import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "AIzaSyCUZ6CZZa8u5v2fBSPcWoC3PwU9BQryT2Q";

class GoogleMapsServices {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    print("dda");
    //var urld = Uri.http(
    //"maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&key=AIzaSyCUZ6CZZa8u5v2fBSPcWoC3PwU9BQryT2Q",
    //"");

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=AIzaSyAsdRXUYIir7nh5_YQ_t_8BFniMsBi2TEc');

    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print(values["routes"][0]["overview_polyline"]["points"]);

    return values["routes"][0]["overview_polyline"]["points"];
  }
}
