import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:map_marker/distance.dart';
import 'package:map_marker/drawer.dart';
import 'package:map_marker/openMap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Activity',
      theme: ThemeData(
        brightness: Brightness.dark,

      ),
      home: MyHomePage(title: 'Marker activity'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final String apiKey = "Your Key Here";

  Distance distance = new Distance();
  bool showloading = false;
  OpenMap openMap = new OpenMap();
  GoogleMapController mapcontroller;
  LatLng markerPosition = _startCam.target;
  List<Marker> markers = List();

  static final CameraPosition _startCam = CameraPosition(
    target: LatLng(7.8731, 80.7718),
    zoom: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(alignment: Alignment.center, children: <Widget>[
        GoogleMap(
            mapType: MapType.normal,
            onCameraMove: _onCameraMove,
            markers: Set<Marker>.of(markers),
            initialCameraPosition: _startCam,
            onMapCreated: (GoogleMapController controller) {
              mapcontroller = controller;
            }),
        Center(
          child: Icon(Icons.nature, color: Colors.red),
        ),
        Positioned(
          bottom: 25,
          left: 25,
          child: _navBtn(),
        ),
        Center(child: _loading()),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _addMarker,
        tooltip: 'Add marker',
        child: Icon(Icons.add),
      ),
      drawer: DrawerMenu(),
    );
  }

  _onCameraMove(CameraPosition position) {
    markerPosition = position.target;
  }

  _addMarker() {
    setState(() {
      MarkerId id = new MarkerId(markerPosition.toString());
      markers.add(Marker(
        markerId: id,
        position: markerPosition,
        infoWindow: InfoWindow(
            title: 'Touch here to remove',
            snippet: 'Location :' + markerPosition.toString(),
            onTap: () => _removeMarker(id)),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  _navBtn(){
    if(!showloading){
    return RaisedButton(
            textColor: Colors.white,
            child: Text('Navigate'),
            color: Colors.black,
            padding: EdgeInsets.all(10),
            onPressed: _openMap,
          );
    }else{
      return RaisedButton(
            textColor: Colors.white,
            child: Row(children: <Widget>[Loading(size: 25, indicator: BallSpinFadeLoaderIndicator(),),Text('\tFetching Navigation')],),
            color: Colors.black,
            padding: EdgeInsets.all(10),
            onPressed: (){},
          );
    }
  }
  _loading() {
    if (showloading) {
      return Loading(
        indicator: BallGridPulseIndicator(),
        size: 50,
      );
    } else {
      return null;
    }
  }

  _removeMarker(MarkerId id) {
    setState(() {
      for (Marker i in markers) {
        if (i.markerId == id) {
          markers.remove(i);
          return;
        }
      }
    });
  }

  _calcShortestDistance(LatLng origin, List<LatLng> list) async {
    int shortDis = 99999999;
    int markerid = 0;
    for (int i = 0; i < list.length; i++) {
      int newDis = await distance.getDistance(origin, list[i], apiKey);
      if (newDis < shortDis) {
        shortDis = newDis;
        markerid = i;
      }
    }
    return markerid;
  }

  _getShortestDistance() async {
    List<LatLng> pos = List();
    List<LatLng> ordered = List();
    markers.forEach((Marker m) {
      pos.add(m.position);
    });
    ordered.add(pos.removeAt(0));
    int startid = 0;
    while (pos.isNotEmpty) {
      LatLng origin = ordered[startid];
      int markerid = await _calcShortestDistance(origin, pos);
      ordered.add(pos.removeAt(markerid));
      startid++;
    }
    return ordered;
  }

  _openMap() async{
    setState(() {
      showloading = true;
    });
    List<LatLng> points = await _getShortestDistance();
    LatLng origin = points.removeAt(0);
    LatLng destination = points.removeLast();
    setState(() {
      showloading = false;
    });
    openMap.openMap(origin, destination, points);
  }
}
