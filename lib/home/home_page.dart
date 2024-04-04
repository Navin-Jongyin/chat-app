import 'package:flutter/material.dart';
import 'package:group_chat/group/group_page.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "Group Chat",
          ),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              print("tapped");
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Enter name"),
                      content: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.length < 3) {
                              return "user must have proper name";
                            }
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              nameController.clear();
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              print(nameController.text);
                              if (formKey.currentState!.validate()) {
                                String name = nameController.text;
                                nameController.clear();
                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        GroupPage(
                                      name: name,
                                      userId: uuid.v1(),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text("Enter")),
                      ],
                    );
                  });
            },
            child: Text("Initiate Group", style: TextStyle(fontSize: 30)),
          ),
        ));
  }
}
