import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class uploadImgaeClass extends StatefulWidget {
  const uploadImgaeClass({Key? key}) : super(key: key);

  @override
  _uploadImgaeClassState createState() => _uploadImgaeClassState();
}

class _uploadImgaeClassState extends State<uploadImgaeClass> {
  final _auth = FirebaseAuth.instance;
  XFile? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uplaod Image"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  uploadFromCamera();
                },
                child: Text("Upload From Camera"),
              ),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  uploadFromGalary();
                },
                child: Text("Upload From Galary"),
              ),
              //displaying image
              Container(
                height: 220.0,
                child: Center(
                  child: Expanded(
                    child: Container(
                      child: Center(
                          child: file != null
                              ? Image(
                                  image: FileImage(
                                    File(file!.path),
                                  ),
                                )
                              : Text("NO Image to upload")),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    uploadImage(
                      File(file!.path),
                    );
                  },
                  child: Text("Upload"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadFromCamera() async {
    file = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      this.file = file;
      File imageFile = File(file!.path);
    });
  }

  Future<void> uploadImage(File imageFile) async {
    String uid = _auth.currentUser!.email.toString();
    final path = 'profileImages/$uid';
    final ref = helperFunction.storageRef.ref().child(path);

    try {
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      print("Image uploaded successfully. URL: $url");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  uploadFromGalary() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }
}
