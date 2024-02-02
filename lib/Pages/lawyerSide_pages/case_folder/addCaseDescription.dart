import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/case_folder/caseManagement.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class addCaseDescription extends StatefulWidget {
  String clientEmail;
  String lawyerEmail;
  addCaseDescription({required this.clientEmail, required this.lawyerEmail});
  @override
  _addCaseDescriptionState createState() => _addCaseDescriptionState();
}

String caseTitle = "";

class _addCaseDescriptionState extends State<addCaseDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Case"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 40, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Lawyer Email",
              style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 71, 70, 70),
                  fontWeight: FontWeight.w600),
            ),
            ListTile(
              title: Text(widget.lawyerEmail),
            ),
            Divider(
              thickness: 3,
            ),
            //client email
            const Text(
              "Client Email",
              style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 71, 70, 70),
                  fontWeight: FontWeight.w600),
            ),
            ListTile(
              title: Text(widget.clientEmail),
            ),
            Divider(
              thickness: 3,
            ),
            //Title
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter Case Title",
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  caseTitle = value;
                  print(caseTitle);
                });
              },
            ),
            Divider(
              thickness: 4,
            ),
            //
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Add Files ",
              style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 71, 70, 70),
                  fontWeight: FontWeight.w600),
            ),
            ElevatedButton(
              onPressed: () {
                pickFile();
              },
              child: ListTile(
                leading: Icon(Icons.file_upload),
                title: Text("Upload File"),
              ),
            ),
            //create Case
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  uploadCase();
                },
                child: Text("Create Case"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // File picked successfully
        String filePath = result.files.single.path!;
        // Use the filePath for further processing

        // Example: Displaying the file name
        String fileName = result.files.single.name;
        print('Picked file: $fileName');
      } else {
        // User canceled the picker
        print('File picking canceled.');
      }
    } catch (e) {
      print(e);
    }
  }

  uploadCase() async {
    try {
      final lawyerRef = helperFunction.lawyerRef;
      final caseRef = helperFunction.caseRef;

      // Add the case data to the caseRef collection
      final caseDocRef = await caseRef.add({
        "lawyerEmail": widget.lawyerEmail,
        "clientEmail": widget.clientEmail,
        "caseNo": "",
        "title": caseTitle,
        "fileList": null,
      });

      // Add the case data to the lawyerRef collection with the specific email
      final querySnapshot =
          await lawyerRef.where('email', isEqualTo: widget.lawyerEmail).get();
      final lawyerDocRef = querySnapshot.docs.first.reference;
      await lawyerDocRef.collection("activeCases").add({
        "lawyerEmail": widget.lawyerEmail,
        "clientEmail": widget.clientEmail,
        "caseNo": caseDocRef.id,
        "title": caseTitle,
        "fileList": null,
      });

      // Update the caseNo field in the caseRef collection with the generated document ID
      await caseDocRef.update({
        "caseNo": caseDocRef.id,
      });

      // Navigate to the next screen
      NextScreen(context, caseManagementPage());
    } catch (e) {
      print(e);
    }
  }
}
