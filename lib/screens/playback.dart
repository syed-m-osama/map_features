import 'package:flutter/material.dart';
import 'package:flutter_animarker/animation/animarker_controller.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Playback extends StatefulWidget {
  const Playback({Key? key}) : super(key: key);

  @override
  State<Playback> createState() => _PlaybackState();
}

class _PlaybackState extends State<Playback> {
  @override
  Widget build(BuildContext context) {
    return MarkerAnimation();
  }
}

//playback
//Setting dummies values
const kStartPosition = LatLng(28.688058, 77.082642);
const kEndPosition = LatLng(28.693094, 77.100302);
const kDelhi = CameraPosition(target: kStartPosition, zoom: 15);
const kMarkerId = MarkerId('MarkerId1');
const kInterval = Duration(milliseconds: 1800);
const kLocations = [
  kStartPosition,
  LatLng(28.688058, 77.083479),
  LatLng(28.688049, 77.084670),
  LatLng(28.688030, 77.086676),
  LatLng(28.687983, 77.087566),
  LatLng(28.688002, 77.089047),
  LatLng(28.687946, 77.090452),
  LatLng(28.687946, 77.091396),
  LatLng(28.687937, 77.092340),
  LatLng(28.687871, 77.093488),
  LatLng(28.688059, 77.094539),
  LatLng(28.688360, 77.095354),
  LatLng(28.689141, 77.095365),
  LatLng(28.688830, 77.095955),
  LatLng(28.689734, 77.096298),
  LatLng(28.691748, 77.097888),
  kEndPosition
];

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class MarkerAnimation extends StatefulWidget {
  @override
  MarkerAnimationState createState() => MarkerAnimationState();
}

class MarkerAnimationState extends State<MarkerAnimation> {
  final markers = <MarkerId, Marker>{};
  final controller = Completer<GoogleMapController>();
  final streamPeriodic =
      Stream.periodic(kInterval, (count) => kLocations[count])
          .take(kLocations.length);
  late StreamController streamController;
  late AnimarkerController animarkerController;
  late GoogleMapController googleMapController;
  late StreamSubscription streamSub;
  bool initialStatus = false;
  bool button1Enabled = true;
  bool button2Enabled = false;
  bool animationComplete = false;

  final Set<Polyline> _polyline = {
    const Polyline(
        polylineId: PolylineId('Set1'),
        points: kLocations,
        width: 2) //describes polyline
  };

  BitmapDescriptor animationMarker = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            'assets/black_car.png')
        .then((onValue) {
      animationMarker = onValue;
    });

    ///StreamController initialised using broadcast(it allows multiple subscription)
    streamController = StreamController.broadcast();
    //streamController.addStream(stream); instead of simply adding, create a StreamSubscription
    ///streamSub(StreamSubscription) subscribed to listen events of streamPeriodic(Stream.periodic())
    streamSub = streamPeriodic.listen((event) {
      streamController.add(event);
    });

    streamSub.pause();

    _getPolyline();

    super.initState();
  }

  void playAnimation() {
    streamSub.onData((data) {
      newLocationUpdate(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              elevation: 10,
              disabledElevation: 0,
              backgroundColor: button1Enabled ? Colors.red : Colors.grey,
              child:
                  animationComplete ? const Text('RESET') : const Text('GO!'),
              onPressed: animationComplete
                  ? () {
                      Navigator.pushReplacementNamed(context, 'playback');
                    }
                  : button1Enabled
                      ? () {
                          playAnimation();
                          streamSub.resume();
                          streamSub.onDone(() {
                            Future.delayed(const Duration(milliseconds: 800),
                                () {
                              setState(() {
                                animationComplete = true;
                                button1Enabled = true;
                                button2Enabled = false;
                              });
                            });
                          });
                          setState(() {
                            button1Enabled = false;
                            button2Enabled = true;
                          });
                        }
                      : null,
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              elevation: 10,
              disabledElevation: 0,
              child: streamSub.isPaused
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause),
              onPressed: button2Enabled
                  ? () {
                      setState(() {});
                      if (streamSub.isPaused) {
                        streamSub.resume();
                      } else {
                        streamSub.pause();
                      }
                    }
                  : null,
              backgroundColor: button2Enabled ? Colors.blue : Colors.grey,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        body: Animarker(
          shouldAnimateCamera: true,
          rippleRadius: 0,
          useRotation: true,
          duration: const Duration(milliseconds: 1800),
          mapId: controller.future.then<int>((value) => value.mapId),
          //Grab Google Map Id
          markers: markers.values.toSet(),
          child: GoogleMap(
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            initialCameraPosition: kDelhi,
            onMapCreated: (gController) {
              googleMapController = gController;
              controller.complete(gController);

              //Complete the future GoogleMapController
            },
          ),
        ),
      ),
    );
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        width: 3,
        color: Colors.red);
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyC-SbnVjcgvgtD9uPx8u0NB655_uqYfO2w",
      PointLatLng(kStartPosition.latitude, kStartPosition.longitude),
      PointLatLng(kEndPosition.latitude, kEndPosition.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  void newLocationUpdate(LatLng latLng) {
    var marker = RippleMarker(
      icon: animationMarker,
      markerId: kMarkerId,
      position: latLng,
      onTap: () {
        log('Tapped! $latLng');
      },
    );
    setState(() => markers[kMarkerId] = marker);
  }
}
