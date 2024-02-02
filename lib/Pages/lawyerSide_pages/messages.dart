import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/chatRoom.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/lawyer_Data.dart';
import 'package:insafchamber/widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class messagesPage extends StatelessWidget {
  final lawyerEmail = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: helperFunction.requestRef
            .where("sendTo", isEqualTo: lawyerEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer(
                child: Container(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("There is some error"),
            );
          } else {
            final snap = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snap.length,
              itemBuilder: (context, index) {
                if (snap.isEmpty) {
                  return Center(child: Text("There is no new messages"));
                } else {
                  return ListTile(
                    onTap: () {
                      String clientName = "";
                      helperFunction.clientRef
                          .where('email', isEqualTo: snap[index]['sendBy'])
                          .get()
                          .then(
                        (value) {
                          value.docs.forEach(
                            (element) {
                              lawyerData.clientList.add(
                                snap[index]['sendBy'],
                              );
                            },
                          );
                        },
                      );

                      NextScreen(
                        context,
                        chatRoom(
                            clientEmail: snap[index]["sendBy"],
                            lawyerEmail: snap[index]["sendTo"],
                            clientName: " "),
                      );
                    },
                    leading: CircleAvatar(),
                    title: Text(
                      snap[index]['sendBy'],
                    ),
                    subtitle: Text(snap[index]['caseType']),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  String getClientData(String emailValue) {
    String name = "";
    helperFunction.clientRef
        .where("email", isEqualTo: emailValue)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        name = element["name"];
      });
    });
    return name;
  }
}
