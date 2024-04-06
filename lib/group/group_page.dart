import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:group_chat/group/msg_model.dart';
import 'package:group_chat/msg_widget/other_msg_widget.dart';
import 'package:group_chat/msg_widget/own_msg_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupPage extends StatefulWidget {
  final String name;

  final String userId;

  const GroupPage({Key? key, required this.name, required this.userId})
      : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  IO.Socket? socket;
  List<MsgModel> listMsg = [];
  TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io("http://localhost:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.onConnect((_) {
      print("frontend connected");
      socket!.on("sendMsgServer", (msg) {
        print("Received message: $msg");
        try {
          if (msg != null && msg is Map<String, dynamic>) {
            final String? type = msg['type'];
            final String? sender = msg['sender'];
            final String? receivedMsg = msg['msg'];
            if (type != null &&
                sender != null &&
                receivedMsg != null &&
                msg["userId"] != widget.userId) {
              setState(() {
                listMsg.add(MsgModel(
                  msg: receivedMsg,
                  type: type,
                  sender: sender,
                ));
              });
            } else {
              print(
                  "One of the properties is null: type=$type, sender=$sender, receivedMsg=$receivedMsg");
            }
          } else {
            print("Invalid message format: $msg");
          }
        } catch (e, stackTrace) {
          print("Error processing message: $e");
          print(stackTrace);
        }
      });
    });
  }

  void sendMsg(String msg, String senderName) {
    MsgModel ownMsg = MsgModel(msg: msg, type: "ownMsg", sender: senderName);
    listMsg.add(ownMsg);
    setState(() {
      listMsg;
    });
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "sender": senderName,
      "userId": widget.userId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuay Group"),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true, // Reverse the order of children
                itemCount: listMsg.length > 4
                    ? 4
                    : listMsg.length, // Show maximum 4 messages
                itemBuilder: (context, index) {
                  final int reversedIndex = listMsg.length - 1 - index;
                  if (listMsg[reversedIndex].type == "ownMsg") {
                    return OwnMsgWidget(
                      msg: listMsg[reversedIndex].msg,
                      sender: listMsg[reversedIndex].sender,
                    );
                  } else {
                    return OtherMsgWidget(
                      msg: listMsg[reversedIndex].msg,
                      sender: listMsg[reversedIndex].sender,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _msgController,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      String msg = _msgController.text;
                      if (msg.isNotEmpty) {
                        sendMsg(_msgController.text, widget.name);
                        _msgController.clear();
                      }
                    },
                    icon: Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }
}
