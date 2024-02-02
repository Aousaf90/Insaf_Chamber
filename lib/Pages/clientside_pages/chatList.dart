import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/clientside_pages/chatRoom.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class chatRoomList extends StatefulWidget {
  const chatRoomList({Key? key}) : super(key: key);

  @override
  _chatRoomListState createState() => _chatRoomListState();
}

String clientEmail = "";
String lawyerEmail = "";

class _chatRoomListState extends State<chatRoomList> {
  @override
  void initState() {
    final _auth = FirebaseAuth.instance.currentUser!.email;
    setState(() {
      clientEmail = _auth.toString();
      print(clientEmail);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: helperFunction.requestRef
            .where('sendBy', isEqualTo: clientEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text("Error loading list");
          } else {
            final snap = snapshot.data!.docs;

            return ListView.builder(
              itemCount: snap.length,
              itemBuilder: (context, index) {
                if (snap.isEmpty) {
                  return Center(
                    child: Text("No NEW MESSAGE"),
                  );
                } else {
                  return ListTile(
                    onTap: () {
                      NextPageFunction(snap[index]["sendTo"]);
                    },
                    leading: CircleAvatar(),
                    title: Text(
                      snap[index]["sendTo"],
                    ),
                    subtitle: Text(
                      snap[index]['message'],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  NextPageFunction(String lawyerEmailValue) {
    print(lawyerEmailValue);
    helperFunction.lawyerRef
        .where("email", isEqualTo: lawyerEmailValue)
        .get()
        .then(
      (value) {
        value.docs.forEach((element) {
          NextScreen(
            context,
            chatRoom(
              clientEmail: clientEmail,
              lawyerEmail: lawyerEmailValue,
              lawyerName: element['name'],
            ),
          );
        });
      },
    );
  }
}
