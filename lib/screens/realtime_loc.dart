import 'package:flutter/material.dart';

class RealtimeLocCapSend extends StatefulWidget {
  const RealtimeLocCapSend({ Key? key }) : super(key: key);

  @override
  State<RealtimeLocCapSend> createState() => _RealtimeLocCapSendState();
}

class _RealtimeLocCapSendState extends State<RealtimeLocCapSend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Realtime Location Capture Send")),
      body: const Center(child: Text('Empty')),
    );
  }
}