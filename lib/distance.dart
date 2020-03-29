import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Distance {
  Distance();

  getDistance(LatLng origin, LatLng destination, String googleApiKey) async {
    int distance = 0;
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=" +
            origin.latitude.toString() +
            "," +
            origin.longitude.toString() +
            "&destination=" +
            destination.latitude.toString() +
            "," +
            destination.longitude.toString() +
            "&mode=driving" +
            "&key=$googleApiKey";
      var response = await http.post(url);
    try {
      if (response?.statusCode == 200) {
        distance = json.decode(response.body)["routes"][0]["legs"][0]
            ["distance"]["value"];
      }
    } catch (error) {
      throw Exception(error.toString());
    }
    return distance;
  }
}
