import 'package:flutter/material.dart';

class RealtimeTracker extends StatefulWidget {
  const RealtimeTracker({ Key? key }) : super(key: key);

  @override
  State<RealtimeTracker> createState() => _RealtimeTrackerState();
}

class _RealtimeTrackerState extends State<RealtimeTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Realtime Tracker")),
      body: const Center(child: Text('Empty')),
    );
  }
}