import 'package:flutter/material.dart';

class LocCustomisedData extends StatefulWidget {
  const LocCustomisedData({ Key? key }) : super(key: key);

  @override
  State<LocCustomisedData> createState() => _LocCustomisedDataState();
}

class _LocCustomisedDataState extends State<LocCustomisedData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Customised Data")),
      body: const Center(child: Text('Empty')),
    );
  }
}