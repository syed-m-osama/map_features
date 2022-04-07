import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
const kDelhi = CameraPosition(target: kStartPosition, zoom: 15);
const kMarkerId = MarkerId('MarkerId1');
const kDuration = Duration(seconds: 2);
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
  LatLng(28.693094, 77.100302),
  kStartPosition
];

class MarkerAnimation extends StatefulWidget {
  @override
  MarkerAnimationState createState() => MarkerAnimationState();
}

class MarkerAnimationState extends State<MarkerAnimation> {
  final markers = <MarkerId, Marker>{};
  final controller = Completer<GoogleMapController>();
  final stream = Stream.periodic(kDuration, (count) => kLocations[count])
      .take(kLocations.length);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Animarker(
        rippleRadius: 0,
        useRotation: true,
        duration: Duration(seconds: 2),
        mapId: controller.future
            .then<int>((value) => value.mapId), //Grab Google Map Id
        markers: markers.values.toSet(),
        child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kDelhi,
            onMapCreated: (gController) {
              stream.forEach((value) => newLocationUpdate(value));
              controller.complete(gController);
              //Complete the future GoogleMapController
            }),
      ),
    );
  }

  void newLocationUpdate(LatLng latLng) {
    var marker = RippleMarker(
        markerId: kMarkerId,
        position: latLng,
        onTap: () {
          log('Tapped! $latLng');
        });
    setState(() => markers[kMarkerId] = marker);
  }
}
