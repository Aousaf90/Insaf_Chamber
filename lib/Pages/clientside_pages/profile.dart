import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final profileImageRef = FirebaseStorage.instance.ref().child("profileImage");
  String imageURL = "";
  File? imageFile;
  final _auth = FirebaseAuth.instance;
  String userRole = "";
  String email = "";
  String name = "";
  String phNumber = "";
  String address = "";
  String resetValue = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageUrl();
    helperFunction.getUsernameStatus().then((value) {
      print(value);
    });
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 40),
          Stack(
            children: [
              //Circuar Avatar Positioned
              Positioned(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(imageURL),
                ),
              ),
              Positioned(
                top: 75,
                left: 75,
                child: IconButton(
                  onPressed: () {
                    showDialoagBox(context);
                  },
                  icon: Icon(Icons.edit, size: 40),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(name),
            trailing: TextButton(
              onPressed: () {},
              child: Icon(Icons.edit),
            ),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text(email),
            trailing: TextButton(
              onPressed: () {},
              child: Icon(Icons.edit),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(phNumber),
            trailing: TextButton(
              onPressed: () {},
              child: Icon(Icons.edit),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(address),
            trailing: TextButton(
              onPressed: () {},
              child: Icon(Icons.edit),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            style: buttonStyle.copyWith(),
            onPressed: resetPassword,
            child: Text(
              "Reset Password",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    @override
    void dispose() {
      super.dispose();
    }
  }

//Functions ..................................
  showDialoagBox(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              child: Text(
                "Change Profile Pic",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SimpleDialogOption(
              child: Text("Choose Photo from Galary"),
              onPressed: () {
                Navigator.pop(context);
                choseFromGalary();
              },
            ),
            SimpleDialogOption(
              child: Text("Take a Live Image"),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  Future<void> getImageUrl() async {
    try {
      // Get the feference to the image file in Firebase Storage
      final ref = profileImageRef.child('aousafsuleman@gmail.com');
// Get teh inageUrl to download URL
      final url = await ref.getDownloadURL();
      if (url.isNotEmpty) {
        setState(
          () {
            imageURL = url;
          },
        );
      }
    } catch (e) {
      print(email);
      print(e);
    }
  }

  choseFromGalary() async {
    final uid = FirebaseAuth.instance.currentUser!.email;
    final path = '$uid';

    // Pick an image from the gallery
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });

      // Upload the image to Firebase Storage
      try {
        await profileImageRef.child(path).putFile(
              File(imageFile!.path),
            );
        print('Image uploaded successfully.');
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      print('No image selected.');
    }
  }

  resetInfo(String value, String resetValue) {
    helperFunction.clientRef.doc(_auth.currentUser!.uid).update(
      {
        '$value': resetValue,
      },
    );
  }

  resetPassword() {
    _auth.sendPasswordResetEmail(email: email).then((value) {
      showSnackbar(
          context, Colors.blue, "Reset Email has been send to your email");
    });
  }

  getUserData() {
    helperFunction.getUserEmailStats().then(
      (value) {
        setState(
          () {
            email = value.toString();
          },
        );
      },
    );
    helperFunction.getUsernameStatus().then(
      (value) {
        setState(
          () {
            name = value.toString();
          },
        );
      },
    );

    try {
      helperFunction.userRef
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          setState(() {
            phNumber = element['phNumber'];
            address = element['address'];
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
