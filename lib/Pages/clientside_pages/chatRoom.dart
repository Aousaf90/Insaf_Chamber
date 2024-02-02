import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/clientside_pages/sendRequest.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/home.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class chatRoom extends StatefulWidget {
  String clientEmail;
  String lawyerEmail;
  String lawyerName;
  String message = "";
  chatRoom(
      {required this.clientEmail,
      required this.lawyerEmail,
      required this.lawyerName});
  @override
  _chatRoomState createState() => _chatRoomState();
}

class _chatRoomState extends State<chatRoom> {
  @override
  final messageTextController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
          ),
          title: Text(
            widget.lawyerName,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              //displaying chatmessages
              child: messageStream(
                widget: widget,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: messageTextController,
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
                decoration: textInputDecoration.copyWith(
                  hintText: "Type your message",
                  suffixIcon: IconButton(
                    onPressed: () {
                      sendMessage(message);
                      messageTextController.clear();
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String message) {
    try {
      if (widget.clientEmail.isNotEmpty && widget.lawyerEmail.isNotEmpty) {
        final ref = helperFunction.messageRef
            .doc(widget.clientEmail)
            .collection(widget.lawyerEmail)
            .doc();

        ref.set({
          "sendBy": widget.clientEmail,
          "message": message,
          "time": DateTime.now(),
        }).catchError((error) {
          // Handle the error here
          print("Error writing message to database: $error");
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

class messageStream extends StatelessWidget {
  const messageStream({
    super.key,
    required this.widget,
  });

  final chatRoom widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: helperFunction.messageRef
          .doc(widget.clientEmail)
          .collection(widget.lawyerEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error loading messages"),
          );
        } else {
          final snap = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: snap.length,
            itemBuilder: (context, index) {
              final reversedIndex = snap.length - 1 - index;
              return messageListTile(
                snap: snap.toList(),
                index: reversedIndex,
              );
            },
          );
        }
      },
    );
  }
}

class messageListTile extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> snap;
  final int index;
  const messageListTile({
    super.key,
    required this.snap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = false;
    if (snap[index]['sendBy'] == FirebaseAuth.instance.currentUser!.email) {
      isMe = true;
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5.0,
            color: isMe ? Colors.black38.withOpacity(0.6) : Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                snap[index]['message'],
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          Text(
            snap[index]['sendBy'],
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
