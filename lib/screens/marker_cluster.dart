import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/helpers/math_util.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerCluster extends StatefulWidget {
  const MarkerCluster({Key? key}) : super(key: key);

  @override
  State<MarkerCluster> createState() => _MarkerClusterState();
}

class _MarkerClusterState extends State<MarkerCluster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MapSample());
  }
}

// Clustering maps
class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late ClusterManager _manager;

  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _googleMapController;

  Set<Marker> markers = Set();

  final CameraPosition _initialCameraPosition =
      const CameraPosition(target: LatLng(23.30039105, 78.13001949), zoom: 4.0);

  List<Place> items = [
    Place(name: 'Delhi', latLng: LatLng(28.644800, 77.216721)),
    Place(
        name: 'Andaman and Nicobar', latLng: LatLng(11.66702557, 92.73598262)),
    Place(name: 'Andhra Pradesh', latLng: LatLng(14.7504291, 78.57002559)),
    Place(name: 'Arunachal Pradesh', latLng: LatLng(27.10039878, 93.61660071)),
    Place(name: 'Assam', latLng: LatLng(26.7499809, 94.21666744)),
    Place(name: 'Goa', latLng: LatLng(15.491997, 73.81800065)),
    for (int i = 1; i < 100; i++)
      Place(
          name: 'Madhya Pradesh',
          latLng: LatLng(21.30039105 + i * 0.1, 76.13001949 + i * 0.1)),
  ];

  @override
  void initState() {
    _manager = _initClusterManager();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    //print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: _initialCameraPosition,
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _manager.setMapId(controller.mapId);
            _googleMapController = controller;
          },
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap),
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            if (cluster.count == 1) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cluster
                            .items.first.name), //returns name of pin_drop
                        Text(cluster.items.first.latLng
                            .toString()) //returns latLng coordinates of pin_drop
                      ],
                    ),
                  );
                },
              );
            } else {
              Future.delayed(Duration(milliseconds: 300), () {
                _googleMapController.animateCamera(CameraUpdate.zoomBy(1.42));
              });
            }
          },
          icon: cluster.isMultiple
              ? await _getMarkerBitmap(125,
                  text: cluster.isMultiple ? cluster.count.toString() : null)
              : BitmapDescriptor
                  .defaultMarker, //ternary condition to check if single item or cluster
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint1 = Paint()..color = Colors.red;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}

class Place with ClusterItem {
  final String name;
  final LatLng latLng;

  Place({
    required this.name,
    required this.latLng,
  });

  @override
  String toString() {
    return 'Place: $name';
  }

  @override
  LatLng get location => latLng;
}

//AIzaSyBZGK3iZrBpP3ylRjWnnliHvASOXtuYycA - Syed Key
