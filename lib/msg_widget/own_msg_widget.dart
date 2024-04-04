import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OwnMsgWidget extends StatelessWidget {
  final String? sender;
  final String? msg;
  const OwnMsgWidget({super.key,required this.sender , required this.msg});


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 60
              ),
        child: Card(
          color: Colors.teal,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    "s,s,aaaa",
                    style: TextStyle(
                      // color: Colors.yellow,
                    ),
                    ),
                    Text(
                    "aaaaaa",
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
