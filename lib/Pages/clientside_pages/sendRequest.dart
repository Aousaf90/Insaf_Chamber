import 'package:flutter/material.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class sendRequestPage extends StatefulWidget {
  String sendByUID;
  String sendToUID;
  sendRequestPage({required this.sendByUID, required this.sendToUID});

  @override
  State<sendRequestPage> createState() => _sendRequestPageState();
}

List requestList = [
  "pending",
  "negotiation",
  "deal",
];
String senderEmail = "";
String reciverEmail = "";
String requestMessage = "";

String caseType = "";
bool sendRequestStatus = false;
String message = "";
Key formKey = GlobalKey<FormState>();

class _sendRequestPageState extends State<sendRequestPage> {
  @override
  void initState() {
    getData();
    getRequestStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Request"),
      ),
      body: sendRequestStatus
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.check),
                      radius: 60,
                    ),
                    SizedBox(height: 5),
                    const Text("Request Send"),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        rejectRequest(senderEmail, reciverEmail);
                      },
                      child: ListTile(
                        iconColor: Colors.white,
                        leading: Icon(Icons.cancel),
                        title: Text(
                          "Cancel Request",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/tarazoo.jpg"),
                    fit: BoxFit.fill,
                    opacity: 0.8),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        label: const Text("type your request message"),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "This field cannot be empty";
                        }
                      },
                      onChanged: (value) {
                        setState(
                          () {
                            message = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButton(
                      hint: Text("Case Type", style: subHeadingStyle),
                      items: [
                        DropdownMenuItem(
                          value: "Tax",
                          child: Text("Tax Case"),
                        ),
                        DropdownMenuItem(
                          value: "Banking",
                          child: Text("Banking Case"),
                        ),
                        DropdownMenuItem(
                          value: "Civil",
                          child: Text("Civil"),
                        ),
                        DropdownMenuItem(
                          value: "Sercice",
                          child: Text("Service"),
                        ),
                        DropdownMenuItem(
                          value: "Label",
                          child: Text("Label Case"),
                        ),
                        DropdownMenuItem(
                          value: "Corporate",
                          child: Text("Corporate Case"),
                        ),
                        DropdownMenuItem(
                          value: "Criminal",
                          child: Text("Criminal Case"),
                        ),
                        DropdownMenuItem(
                          value: "Insurance",
                          child: Text("Insurance Case"),
                        ),
                        DropdownMenuItem(
                          value: "Family",
                          child: Text("Family Case"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(
                          () {
                            caseType = value.toString();
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: double.infinity,
                          height: 400,
                          child: Center(
                            child: Column(
                              children: [
                                //reciver email
                                ListTile(
                                  leading: Icon(Icons.send_to_mobile),
                                  title: Text(
                                    reciverEmail,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                //sender email
                                ListTile(
                                  leading: Icon(
                                    Icons.person,
                                  ),
                                  title: Text(
                                    senderEmail,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.message),
                                  title: Text(
                                    message,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ListTile(
                                  leading: Text("Case Type"),
                                  title: (Text(caseType)),
                                ),
                                ElevatedButton(
                                  style: buttonStyle,
                                  onPressed: () {
                                    sendRequest();
                                  },
                                  child: ListTile(
                                    iconColor: Colors.white,
                                    textColor: Colors.white,
                                    leading: Icon(Icons.send),
                                    title: Text("Send Request"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  getRequestStatus() {
    helperFunction.requestRef
        .where("sendTo", isEqualTo: reciverEmail)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          sendRequestStatus = element["sendRequestStatus"];
        });
        print("Firebase $sendRequestStatus");
      });
    });
  }

//getting data
  getData() {
    try {
      helperFunction.getUserEmailStats().then(
        (value) {
          setState(
            () {
              senderEmail = value.toString();
            },
          );
        },
      );
      final ref = helperFunction.userRef;
      ref.where('uid', isEqualTo: widget.sendToUID).get().then(
        (value) {
          value.docs.forEach(
            (element) {
              setState(
                () {
                  reciverEmail = element['email'];
                  print(reciverEmail);
                },
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

//send request function
  sendRequest() async {
    try {
      await helperFunction.requestRef.doc().set(
        {
          "sendBy": senderEmail,
          "sendTo": reciverEmail,
          "message": message,
          "caseType": caseType,
          "requestStage": helperFunction.requestStatus[0],
          "sendRequestStatus": true,
        },
      ).then((value) {
        setState(() {
          sendRequestStatus = true;
        });
      });
    } catch (e) {
      print(e);
    }
    print(sendRequestStatus);
  }

//reject Request
  Future<void> rejectRequest(String email, String secondEmail) async {
    final querySnapshot = await helperFunction.requestRef
        .where('sendBy', isEqualTo: email)
        .where('sendTo', isEqualTo: secondEmail)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (final docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete().then((value) {
          Navigator.pop(context);
          sendRequestStatus = false;
        });
      }
    }
  }
}
