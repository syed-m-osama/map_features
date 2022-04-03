import 'package:flutter/material.dart';
import 'screens/playback.dart';
import 'screens/realtime_tracker.dart';
import 'screens/geo_fencing.dart';
import 'screens/marker_cluster..dart';
import 'screens/route_mapping.dart';
import 'screens/map_icon_change.dart';
import 'screens/realtime_loc.dart';
import 'screens/loc_customised_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      routes: {
        "realtime_loc": (context) => const RealtimeLocCapSend(),
        "route_mapping": (context) => const RouteMapping(),
        "map_icon_change": (context) => const MapIconChange(),
        "loc_customised_data": (context) => const LocCustomisedData(),
        "marker_cluster": (context) => const MarkerCluster(),
        "geo_fencing": (context) => const GeoFencing(),
        "realtime_tracker": (context) => const RealtimeTracker(),
        "playback":(context) => const Playback()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            RouteButton(title: 'Realtime Loc Cap Send', routeName: 'realtime_loc'),
            RouteButton(title: 'Route Mapping', routeName: 'route_mapping'),
            RouteButton(title: 'Map Icon Change', routeName: 'map_icon_change'),
            RouteButton(title: 'Loc Customised Data', routeName: 'loc_customised_data'),
            RouteButton(title: 'Marker Cluster', routeName: 'marker_cluster'),
            RouteButton(title: 'Geo-Fencing', routeName: 'geo_fencing'),
            RouteButton(title: 'Realtime Tracker', routeName: 'realtime_tracker'),
            RouteButton(title: 'PlayBack', routeName: 'playback')

          ],
        ),
      ),
    );
  }
}


class RouteButton extends StatelessWidget {
  const RouteButton({ Key? key ,required this.title, required this.routeName}) : super(key: key);

  final String title;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => Navigator.pushNamed(context, routeName),
      child: Text(title),
      textColor: Colors.white,
      color: Colors.green[600]);
  }
}