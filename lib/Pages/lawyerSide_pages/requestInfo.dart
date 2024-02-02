import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/chatRoom.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/home.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class requestInfo extends StatefulWidget {
  final snap;
  final index;

  requestInfo({
    required this.snap,
    required this.index,
  });

  @override
  _requestInfoState createState() => _requestInfoState();
}

String clientName = "";

class _requestInfoState extends State<requestInfo> {
  @override
  void initState() {
    try {
      helperFunction.clientRef
          .where("email", isEqualTo: widget.snap[widget.index]["sendBy"])
          .get()
          .then((value) {
        value.docs.forEach((element) {
          setState(() {
            clientName = element["name"];
          });
        });
      });
    } catch (e) {
      print(e);
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.black,
        ),
        onPressed: () {
          caseStateUp(widget.snap[widget.index]["sendBy"],
              widget.snap[widget.index]["sendTo"]);
        },
      ),
      appBar: AppBar(
        title: Text(
          "Case Request No " + (widget.index + 1).toString(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            //ChatModule
            Container(
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Request By: $clientName"),
                      ),
                      //sender Email,
                      ListTileDataSet(
                        data: widget.snap[widget.index]["sendBy"],
                        leadingIcon: Icon(Icons.email),
                      ),
                      ListTileDataSet(
                        data: "Case Type: " +
                            widget.snap[widget.index]["caseType"],
                        leadingIcon: Icon(Icons.file_copy),
                      ),
                      ListTileDataSet(
                        data: widget.snap[widget.index]["message"],
                        leadingIcon: Icon(Icons.message),
                      ),
                      const SizedBox(height: 60),
                      //Button Row

                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ListTile(
                          onTap: () {
                            rejectRequest(widget.snap[widget.index]["sendBy"],
                                widget.snap[widget.index]["sendTo"]);
                          },
                          leading: Icon(Icons.cancel),
                          title: Text("Cancel Request"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> caseStateUp(String email, reciverEmail) async {
    String clientName = "";
    final querySnapshot = await helperFunction.requestRef
        .where('sendBy', isEqualTo: email)
        .where("sendTo", isEqualTo: reciverEmail)
        .get();

    final batchUpdate = FirebaseFirestore.instance.batch();
    querySnapshot.docs.forEach((doc) {
      batchUpdate.update(doc.reference, {
        'requestStage': helperFunction.requestStatus[1],
      });
    });
    helperFunction.clientRef.where("email", isEqualTo: email).get().then(
      (value) {
        value.docs.forEach((element) {
          NextScreen(
            context,
            chatRoom(
              clientEmail: email,
              lawyerEmail: reciverEmail,
              clientName: element['name'],
            ),
          );
        });
      },
    );

    try {
      await batchUpdate.commit();
      print('Names updated successfully.');
    } catch (e) {
      print('Error updating names: $e');
    }
  }

  Future<void> rejectRequest(String email, String secondEmail) async {
    final querySnapshot = await helperFunction.requestRef
        .where('sendBy', isEqualTo: email)
        .where('sendTo', isEqualTo: secondEmail)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (final docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete().then((value) {
          Navigator.pop(context);
        });
      }
    }
  }
}

class ListTileDataSet extends StatelessWidget {
  String data;
  Icon leadingIcon;
  ListTileDataSet({
    required this.data,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon,
      title: Text(data),
    );
  }
}
