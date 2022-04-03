import 'package:flutter/material.dart';

class MapIconChange extends StatefulWidget {
  const MapIconChange({ Key? key }) : super(key: key);

  @override
  State<MapIconChange> createState() => _MapIconChangeState();
}

class _MapIconChangeState extends State<MapIconChange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map Icon Change")),
      body: const Center(child: Text('Empty')),
    );
  }
}