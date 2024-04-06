import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherMsgWidget extends StatelessWidget {
  final String sender;
  final String msg;
  const OtherMsgWidget({super.key, required this.sender, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60),
        child: Card(
          color: const Color.fromARGB(255, 150, 40, 0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: TextStyle(
                        // color: Colors.yellow,
                        ),
                  ),
                  Text(
                    msg,
                    style: TextStyle(
                        // color: Colors.yellow,
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
