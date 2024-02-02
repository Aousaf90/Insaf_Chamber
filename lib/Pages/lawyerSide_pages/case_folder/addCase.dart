import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/clientside_pages/searchPage.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/case_folder/addCaseDescription.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class clientListClass extends StatefulWidget {
  String uidValue;
  String emailValue;
  clientListClass({required this.emailValue, required this.uidValue});

  @override
  _addCaseState createState() => _addCaseState();
}

List<Widget> clientList = [];

class _addCaseState extends State<clientListClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_right, color: Colors.black, size: 50),
          onPressed: () {
            NextScreen(context, PageRoute);
          },
        ),
        appBar: AppBar(
          title: const Text("Add to List"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/insafkaTarazoo.jpg"),
                opacity: 0.5,
                fit: BoxFit.cover),
          ),
          child: Container(
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: clientListStreamBuilder(
                      widget: widget, lawyerEmailValue: widget.emailValue),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ));
  }
}

class clientListStreamBuilder extends StatelessWidget {
  const clientListStreamBuilder({
    required this.lawyerEmailValue,
    super.key,
    required this.widget,
  });
  final String lawyerEmailValue;
  final clientListClass widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: helperFunction.requestRef
          .where("sendTo", isEqualTo: widget.emailValue)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: clientListTile(
                    snap: snap,
                    index: index,
                    lawyerEmail: lawyerEmailValue,
                    clientEmail: snap[index]['sendBy'],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}

class clientListTile extends StatelessWidget {
  const clientListTile({
    super.key,
    required this.snap,
    required this.index,
    required this.clientEmail,
    required this.lawyerEmail,
  });
  final String lawyerEmail;
  final String clientEmail;
  final int index;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> snap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        NextScreen(
            context,
            addCaseDescription(
              clientEmail: clientEmail,
              lawyerEmail: lawyerEmail,
            ));
      },
      leading: CircleAvatar(),
      title: Text(
        snap[index]['sendBy'],
      ),
      subtitle: Text(snap[index]['caseType']),
    );
  }
}
