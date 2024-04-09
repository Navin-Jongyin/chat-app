import 'package:flutter/material.dart';

class MsgModel {
  String groupId;
  String msg;
  String sender;
  MsgModel(
      { required this.groupId,
        required this.msg,
        required this.sender});
}
