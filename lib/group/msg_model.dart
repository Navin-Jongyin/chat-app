import 'package:flutter/material.dart';

class MsgModel{
  String type;
  String msg;
  String sender;
  MsgModel({
    required this.msg,
    required this.type,
    required this.sender
    });
}