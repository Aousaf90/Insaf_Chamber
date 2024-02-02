import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/case_folder/activeCase.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/case_folder/addCase.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/lawyer_Data.dart';
import 'package:insafchamber/widget.dart';
import 'package:lottie/lottie.dart';

class caseManagementPage extends StatefulWidget {
  @override
  State<caseManagementPage> createState() => _caseManagementPageState();
}

String email = "";
String uid = "";
final _auth = FirebaseAuth.instance;
List<Widget> caseCount = [
  fileBox(),
];

Widget fileBox() {
  return Container(
    width: 30,
    height: 30,
    child: Icon(Icons.folder, size: 100),
  );
}

class _caseManagementPageState extends State<caseManagementPage> {
  @override
  void initState() {
    setState(() {
      email = _auth.currentUser!.email.toString();
      uid = _auth.currentUser!.uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listofCases(),
      floatingActionButton: TextButton(
          child: LottieBuilder.network(
            "https://assets4.lottiefiles.com/packages/lf20_QzXnllXNWv.json",
            height: 100,
            width: 100,
          ),
          onPressed: () {
            setState(() {
              addCase();
            });
          }),
    );
  }

  //Functions
  addCase() {
    //adding new Case to the List
    // setState(() {
    //   caseCount.add(
    //     fileBox(),
    //   );
    // });
    NextScreen(context, clientListClass(emailValue: email, uidValue: uid));
  }
}

class listofCases extends StatelessWidget {
  const listofCases({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int count = 3;
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.3,
            image: AssetImage('images/LawPen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: helperFunction.caseRef
              .where("lawyerEmail", isEqualTo: _auth.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final snap = snapshot.data!.docs;
              return GridView.builder(
                itemCount: snap.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  if (snap.isEmpty) {
                    return Text("There is no Case to Show");
                  }
                  return caseFolder(
                    snap: snap,
                    index: index,
                  );
                },
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            return Center(child: Text("No Data"));
          },
        ));
  }
}

//case management folder
class caseFolder extends StatelessWidget {
  const caseFolder({
    super.key,
    required this.snap,
    required this.index,
  });
  final int index;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> snap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          NextScreen(
            context,
            activeCase(
              clientEmail: snap[index]['clientEmail'],
              lawyerEmail: _auth.currentUser!.email.toString(),
              title: snap[index]['title'],
              caseID: snap[index]['caseNo'],
            ),
          );
        } catch (e) {
          print(e);
        }
      },
      child: Column(
        children: [
          Icon(Icons.folder, size: 70),
          Center(
            child: Text(
              snap[index]['title'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
