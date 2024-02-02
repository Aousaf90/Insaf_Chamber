import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/case_folder/modifyHistory.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';
import 'package:lottie/lottie.dart';

class activeCase extends StatefulWidget {
  String clientEmail;
  String lawyerEmail;
  String title;
  String caseID;
  activeCase(
      {required this.clientEmail,
      required this.lawyerEmail,
      required this.title,
      required this.caseID});
  @override
  _activeCaseState createState() => _activeCaseState();
}

class _activeCaseState extends State<activeCase> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: primaryColor,
                  ),
                  //First Box
                  child: firstBox(
                    widget: widget,
                  ),
                ),
                Row(
                  children: [
                    Divider(
                      thickness: 3,
                      color: primaryColor,
                    ),
                    const Text(
                      "Recent Files",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        pickFile();
                      },
                      child: LottieBuilder.network(
                        "https://assets10.lottiefiles.com/packages/lf20_t7ndwywl.json",
                        height: 120,
                        width: 120,
                      ),
                    ),
                  ],
                ),
                //File management
                fileUploadContainer(
                  caseID: widget.caseID,
                ),
                //History
                const SizedBox(height: 40),
                const Text(
                  "History",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
//History Container
                Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: double.infinity,
                          height: 270,
                        ),
                      ),
                      // addCase Widget
                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          modifyHistory(
                            widget.clientEmail,
                            widget.lawyerEmail,
                            widget.title,
                          );
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Functions .......
  modifyHistory(String clientEmail, String lawyerEmail, String title) {
    NextScreen(
        context,
        modifyHistoryClass(
          clientEmail: clientEmail,
          lawyerEmail: lawyerEmail,
          title: title,
        ));
  }

  Future<String> uploadFile(String fileName, File file) async {
    final caseID = widget.caseID;
    final ref = await FirebaseStorage.instance
        .ref()
        .child("caseManagement/$caseID/$fileName");
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => null);
    final downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  // void getFile() async {
  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );
    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadFile(fileName, file);
      final caseRef = await helperFunction.caseRef
          .where("caseNo", isEqualTo: widget.caseID)
          .get();
      final fileRef = caseRef.docs.first.reference;
      await fileRef.collection("files").add({
        "title": fileName,
        "url": downloadLink,
        "date": Timestamp.fromDate(DateTime.now()),
      });
      print("file uploaded");
    }
  }
}

class fileUploadContainer extends StatelessWidget {
  String caseID;
  fileUploadContainer({required this.caseID});

  @override
  // void initState() {
  //   getFile();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: StreamBuilder(
        stream:
            helperFunction.caseRef.doc(caseID).collection("files").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("There is an error");
          }

          if (!snapshot.hasData) {
            return Text("Loading data..."); // or any other loading widget
          }
          if (snapshot.hasData == null) {
            return Text("NO Data");
          }
          final snap = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snap.length,
            itemBuilder: (context, index) {
              // Inside the ListView.builder
              if (snap.isEmpty) {
                return Text("NO DATA");
              } else if (snap[index].data().containsKey('title')) {
                return Container(
                  child: GestureDetector(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        LottieBuilder.network(
                          "https://assets2.lottiefiles.com/temp/lf20_YMAG36.json",
                          height: 100,
                          width: 100,
                        ),
                        Text(
                          snap[index]['title'],
                          overflow: TextOverflow.clip,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return LottieBuilder.network(
                    "https://assets8.lottiefiles.com/packages/lf20_Dczay3.json");
              }
            },
          );
        },
      ),
    );
  }
}

class firstBox extends StatelessWidget {
  const firstBox({
    super.key,
    required this.widget,
  });

  final activeCase widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Divider(
          thickness: 2,
        ),
        const SizedBox(height: 5),
        Text(
          "Lawyer: " + widget.lawyerEmail,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: seccondaryColor),
        ),
        const SizedBox(height: 5),
        Text(
          "Client:   " + widget.clientEmail,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: seccondaryColor),
        ),
        TextButton(
          child: Text(
            "Detail Analogy ",
            style: TextStyle(
              fontSize: 18,
              color: seccondaryColor,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
