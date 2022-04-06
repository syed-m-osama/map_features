import 'dart:async';
import 'dart:ui';

import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GeoFencing extends StatefulWidget {

  @override
  _GeoFencingState createState() => _GeoFencingState();
}

class _GeoFencingState extends State<GeoFencing> {


  // TextEditingController latitudeController = new TextEditingController();
  // TextEditingController longitudeController = new TextEditingController();
  // TextEditingController radiusController = new TextEditingController();
  // double latitudeController = 12.9581236;
  // double longitudeController = 77.493086;
  // double radiusController= 250;
  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  String geofenceStatus = '';
  bool isReady = false;
  Position? position;


  CameraPosition _initialLocation = CameraPosition(
      target: LatLng(12.961025, 77.512688), zoom: 15);
  late GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  // TextEditingController _searchController = TextEditingController();
  // final startAddressController = TextEditingController();
  // late ClusterManager _manager;


  late Position _currentPosition;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Marker> _markers = [];

  @override
  void initState() {
    getCurrentPosition();
    initialize();
    setLocation();
    super.initState();
  }


  initialize() {
    // Marker marker1 = Marker(
    //   markerId: MarkerId('id-1'),
    //   position: LatLng(13.0496, 77.5439),
    //   infoWindow: InfoWindow(
    //       title: 'Jalahalli cross',
    //       snippet: 'description'
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    // );
    Marker marker2 = Marker(
      markerId: MarkerId('id-2'),
      position: LatLng(12.9581236, 77.493086),
      infoWindow: InfoWindow(
          title: 'Kengeri',
          snippet: 'The description can be added here'
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    Marker marker3 = Marker(
      markerId: MarkerId('id-3'),
      position: LatLng(13.089093, 77.410416),
      infoWindow: InfoWindow(
          title: 'Nelamangala town',
          snippet: 'description'
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    Marker marker4 = Marker(
      markerId: MarkerId('id-4'),
      position: LatLng(13.107568, 77.571198),
      infoWindow: InfoWindow(
          title: 'Yelahanka',
          snippet: 'description'
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    // Marker marker5 = Marker(
    //   markerId: MarkerId('id-5'),
    //   position: LatLng(13.138558, 77.477890),
    //   infoWindow: InfoWindow(
    //       title: 'Hesarghatta',
    //       snippet: 'description'
    //   ),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    // );
    Marker marker6 = Marker(
      markerId: MarkerId('id-6'),
      position: LatLng(12.971891, 77.641151),
      infoWindow: InfoWindow(
          title: 'Indiranagar',
          snippet: 'description'
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    //_markers.add(marker1);
    _markers.add(marker2);
    _markers.add(marker3);
    _markers.add(marker4);
    // _markers.add(marker5);
    _markers.add(marker6);

    setState(() {

    });
  }


  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("LOCATION => ${position!.toJson()}");
    isReady = (position != null) ? true : false;
  }
  setLocation() async {
    await getCurrentPosition();
    print("POSITION => ${position!.toJson()}");
    // latitudeController =
    //     TextEditingController(text: position!.latitude.toString());
    // print('latitudecontroller: $latitudeController');
    // longitudeController =
    //     TextEditingController(text: position!.longitude.toString());
  }

  // Method for retrieving the current location
  // _getCurrentLocation() async {
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) async {
  //     setState(() {
  //       _currentPosition = position;
  //       print('CURRENT POS: $_currentPosition');
  //       mapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: LatLng(position.latitude, position.longitude),
  //             zoom: 18.0,
  //           ),
  //         ),
  //       );
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  Set<Circle> myCircles = Set.from([Circle(
    circleId: CircleId("1"),
    center: LatLng(12.9581236, 77.493086),
    radius: 1100,
    strokeWidth: 1,
  )]);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Maps"),),
      body: Column(
        children: <Widget>[
          // Row(children: [
          //   Expanded(
          //   child: TextFormField(
          //     controller: _searchController,
          //     textCapitalization: TextCapitalization.words,
          //     decoration: InputDecoration(hintText: 'Search by city'),
          //     onChanged: (value){
          //       print(value);
          //       },
          //   )),
          //   IconButton(
          //       onPressed: ()  { //async var place = await
          //       LocationService().getPlaceId(_searchController.text);
          //         //_goToPlace(place);
          //       },
          //       icon: Icon(Icons.search)),
          // ],),

          // Map View
          Expanded(
            child: GoogleMap(
              circles: myCircles,
              markers: _markers.map((e) => e).toSet(),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),

          ),

          // TextField(
          //   controller: latitudeController,
          //   decoration: InputDecoration(
          //       border: InputBorder.none, hintText: 'Enter pointed latitude'),
          // ),
          // TextField(
          //   controller: longitudeController,
          //   decoration: InputDecoration(
          //       border: InputBorder.none,
          //       hintText: 'Enter pointed longitude'),
          // ),
          // TextField(
          //   controller: radiusController,
          //   decoration: InputDecoration(
          //       border: InputBorder.none, hintText: 'Enter radius in meter'),
          // ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: deprecated_member_use
              RaisedButton(
                child: Text("Start"),
                onPressed: () {
                  print("starting geoFencing Service");
                  EasyGeofencing.startGeofenceService(
                      pointedLatitude: "12.9581236",
                      //latitudeController.text,
                      pointedLongitude: "77.493086",
                      //longitudeController.text,
                      radiusMeter: "1100.0",
                      //radiusController.text,
                      eventPeriodInSeconds: 5);

                  if (geofenceStatusStream == null) {
                    geofenceStatusStream = EasyGeofencing.getGeofenceStream()!
                        .listen((GeofenceStatus status) {
                      print(status.toString());
                      setState(() {
                        geofenceStatus = status.toString();
                      });
                    });
                  }
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                child: Text("Stop"),
                onPressed: () {
                  print("stop");
                  EasyGeofencing.stopGeofenceService();
                  //geofenceStatusStream!.cancel();
                },
              ),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Text(
            "Geofence Status: \n\n\n" + geofenceStatus,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),

        ],

      ),

    );
  }
// Future<void> _goToPlace(Map<String, dynamic> place) async{
//   final double lat = place['geometry']['location']['lat'];
//   final double lng = place['geometry']['location']['lng'];
//   final GoogleMapController controller = await _controller.future;
//   controller.animateCamera(CameraUpdate.newCameraPosition(
//   CameraPosition(target: LatLng(lat, lng), zoom: 12)
//   ));
// }
}
