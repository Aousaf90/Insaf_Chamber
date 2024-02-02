import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/client_data.dart';
import 'package:insafchamber/helpterFunctions.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

String myEmail = "";

class _homePageState extends State<homePage> {
  @override
  void initState() {
    clientData Cdata = clientData();
    setState(() {
      myEmail = Cdata.email;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(),
          child: Column(
            children: [
              const Text(
                "Request SEND",
                style: TextStyle(fontSize: 20),
              ),
              StreamBuilder(
                stream: helperFunction.requestRef
                    .where("sendBy", isEqualTo: myEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Icon(Icons.person),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("There is some error loading list"));
                  } else if (snapshot.hasData == null) {
                    return Center(
                      child: Text("There is no data"),
                    );
                  } else {
                    final snap = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          if (snap.isEmpty) {
                            return Center(
                              child: Text("No New Requet"),
                            );
                          }
                          return requestTile(
                            snap: snap,
                            index: index,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Divider(
                thickness: 2,
                indent: 1,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class requestTile extends StatelessWidget {
  final int index;
  const requestTile({
    super.key,
    required this.index,
    required this.snap,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> snap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          padding: EdgeInsets.all(2),
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(
              snap[index]['sendTo'],
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              snap[index]['caseType'],
            ),
            trailing: Text(
              snap[index]['requestStage'],
            ),
          ),
        ),
      ],
    );
  }
}
