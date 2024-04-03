import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupPage extends StatefulWidget {
  final String name;
  const GroupPage({super.key, required this.name});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  IO.Socket? socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ok");
  }

  void connect() {
    socket = IO.io("http//localhost:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoconnect": false,
    });
    socket!.connect();
    print("we re here");
    socket!.onConnect((_) {
      print('connect');
      socket!.emit('msg', 'test');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuay Group"),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              children: [
                Expanded(child: TextFormField()),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
