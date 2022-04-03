import 'package:flutter/material.dart';

class Playback extends StatefulWidget {
  const Playback({ Key? key }) : super(key: key);

  @override
  State<Playback> createState() => _PlaybackState();
}

class _PlaybackState extends State<Playback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Playback")),
      body: const Center(child: Text('Empty')),
    );
  }
}