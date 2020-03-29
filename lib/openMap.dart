import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenMap{
  openMap(LatLng origin, LatLng destination, List<LatLng> points) async {
    String params = "";
    String origins = "&origin=" +
        origin.latitude.toString() +
        "," +
        origin.longitude.toString();
    String desti = "&destination=" +
        destination.latitude.toString() +
        "," +
        destination.longitude.toString();
    String waypoints = "&waypoints=";
    for (LatLng p in points) {
      waypoints += p.latitude.toString() +
          "," +
          p.longitude.toString() +
          "|";
    }
    params = origins + desti + waypoints;
    String url = "https://www.google.com/maps/dir/?api=1&" + params;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}