import 'package:flutter/material.dart';

class MarkerCluster extends StatefulWidget {
  const MarkerCluster({ Key? key }) : super(key: key);

  @override
  State<MarkerCluster> createState() => _MarkerClusterState();
}

class _MarkerClusterState extends State<MarkerCluster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Marker Cluster")),
      body: const Center(child: Text('Empty')),
    );
  }
}