// import 'package:flutter/material.dart';
// import 'package:group_chat/group/group_page.dart';
// import 'package:uuid/uuid.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   TextEditingController nameController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   var uuid = Uuid();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: const Text("Group Chat"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextButton(
//               onPressed: () {
//                 _showGroupNameDialog("Group 1");
//               },
//               child: Text(
//                 "Group 1",
//                 style: TextStyle(fontSize: 30),
//               ),
//             ),
//             SizedBox(height: 20), // Add some spacing between buttons
//             TextButton(
//               onPressed: () {
//                 _showGroupNameDialog("Group 2");
//               },
//               child: Text(
//                 "Group 2",
//                 style: TextStyle(fontSize: 30),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showGroupNameDialog(String groupName) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String groupId = uuid.v4(); // Generate unique group ID
//         return AlertDialog(
//           title: Text("Enter name for $groupName"),
//           content: Form(
//             key: formKey,
//             child: TextFormField(
//               controller: nameController,
//               validator: (value) {
//                 if (value == null || value.isEmpty || value.length < 3) {
//                   return "User must have a proper name";
//                 }
//                 return null;
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 nameController.clear();
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   String name = nameController.text;
//                   nameController.clear();
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => GroupPage(
//                         name: name,
//                         userId: uuid.v1(),
//                         groupId: groupId,
//                         groupName: groupName
//                       ),
//                     ),
//                   );
//                   print("group name:$groupName");
//                   print("groupId:$groupId");
//                 }
//               },
//               child: const Text("Enter"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:group_chat/group/group_page.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
        title: const Text("Group Chat"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _showGroupNameDialog("Group 1", "1");
              },
              child: Text(
                "Group 1",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: 20), // Add some spacing between buttons
            TextButton(
              onPressed: () {
                _showGroupNameDialog("Group 2", "2");
              },
              child: Text(
                "Group 2",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupNameDialog(String groupName, String groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter name for $groupName"),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 3) {
                  return "User must have a proper name";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String name = nameController.text;
                  nameController.clear();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => GroupPage(
                        name: name,
                        userId: uuid.v1(), // Using groupId directly
                        groupName: groupName,
                        groupId: groupId,
                      ),
                    ),
                  );
                  print("group name: $groupName , groupId: $groupId");
                }
              },
              child: const Text("Enter"),
            ),
          ],
        );
      },
    );
  }
}
