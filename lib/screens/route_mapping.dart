import 'package:flutter/material.dart';

class RouteMapping extends StatefulWidget {
  const RouteMapping({ Key? key }) : super(key: key);

  @override
  State<RouteMapping> createState() => _RouteMappingState();
}

class _RouteMappingState extends State<RouteMapping> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Mapping")),
      body: const Center(child: Text('Empty')),
    );
  }
}