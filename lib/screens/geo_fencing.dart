import 'package:flutter/material.dart';

class GeoFencing extends StatefulWidget {
  const GeoFencing({ Key? key }) : super(key: key);

  @override
  State<GeoFencing> createState() => _GeoFencingState();
}

class _GeoFencingState extends State<GeoFencing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geo-Fencing")),
      body: const Center(child: Text('Empty')),
    );
  }
}