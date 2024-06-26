import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:group_chat/group/msg_model.dart';
import 'package:group_chat/msg_widget/own_msg_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupPage extends StatefulWidget {
  final String name;
  final String userId;
  final String groupName;
  final String groupId;

  const GroupPage(
      {Key? key,
      required this.name,
      required this.userId,
      required this.groupName,
      required this.groupId})
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
            final String groupId = msg['groupId'];
            final String? sender = msg['sender'];
            final String? receivedMsg = msg['msg'];
            if (sender != null &&
                receivedMsg != null &&
                msg["userId"] != widget.userId &&
                msg["groupId"] == widget.groupId) {
              setState(() {
                listMsg.add(MsgModel(
                  groupId: groupId,
                  msg: receivedMsg,
                  sender: sender,
                ));
              });
            } else {
              print(
                  "One of the properties is null: , sender=$sender, receivedMsg=$receivedMsg");
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

  void sendMsg(String groupId,String msg, String senderName) {
    MsgModel ownMsg = MsgModel(groupId: groupId,msg: msg, sender: senderName);
    listMsg.add(ownMsg);
    setState(() {
      listMsg;
    });
    socket!.emit('sendMsg', {
      "groupId": groupId,
      "msg": msg,
      "sender": senderName,
      "userId": widget.userId,
    });
  }



@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.red,
      title: Text(widget.groupName), // Display group name on the app bar
    ),
    body: Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Colors.red,
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Minimize the height of the column
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true, // Reverse the order of children
                itemCount: listMsg.length > 4
                    ? 4
                    : listMsg.length, // Show maximum 4 messages
                itemBuilder: (context, index) {
                  final int reversedIndex = listMsg.length - 1 - index;
                  return OwnMsgWidget(
                    msg: listMsg[reversedIndex].msg,
                    sender: listMsg[reversedIndex].sender,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
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
                        sendMsg(widget.groupId,_msgController.text, widget.name);
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
    ),
  );
}
}
