import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insafchamber/Pages/mainPage.dart';
import 'package:insafchamber/authentication/uploadImage.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:lottie/lottie.dart';

import '../widget.dart';

class registerUser extends StatefulWidget {
  const registerUser({Key? key}) : super(key: key);

  @override
  _registerUserState createState() => _registerUserState();
}

class _registerUserState extends State<registerUser> {
  final formKey = GlobalKey<FormState>();
  XFile? file;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String email = "";
  String password = "";
  String name = "";
  String address = "";
  String phNumber = "";
  String uid = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.network(
                          "https://assets1.lottiefiles.com/packages/lf20_wWZd8QJ7Cj.json"),
                      //LOGIN CONTAINER
                      const SizedBox(height: 20),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const Text(
                                "Register User",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 40),
                              // Email Field
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  label: const Text("Enter your Email"),
                                ),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      email = value;
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              // Name Field
                              TextFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return "Field can not be Empty";
                                  } else
                                    return null;
                                },
                                decoration: textInputDecoration.copyWith(
                                  label: const Text("Enter your Full Name"),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              //Phone Number Field
                              TextFormField(
                                validator: (value) {
                                  if (value!.length < 11) {
                                    return "Password should be atleast 6 character";
                                  } else if (value == null) {
                                    return "Form Can not be Empty";
                                  } else
                                    return null;
                                },
                                decoration: textInputDecoration.copyWith(
                                  label: const Text("Enter your Phone Number"),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    phNumber = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              //address Field
                              TextFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return "Form Cannot be Empty";
                                  } else
                                    return null;
                                },
                                decoration: textInputDecoration.copyWith(
                                  label: const Text("Enter your Address"),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    address = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),

                              //Password Field
                              TextFormField(
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return "Password should be atleast 6 character";
                                  } else
                                    return null;
                                },
                                decoration: textInputDecoration.copyWith(
                                  label: const Text("Enter your Password"),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                validator: (value) {
                                  if (value != password) {
                                    return "Enter same password as above";
                                  } else
                                    return null;
                                },
                                decoration: textInputDecoration.copyWith(
                                  label: const Text("Re enter Your Password"),
                                ),
                              ),

                              const SizedBox(height: 10),
                              //uploadImage dialog
                              ElevatedButton(
                                style: buttonStyle,
                                onPressed: () {
                                  NextScreen(context, uploadImgaeClass());
                                },
                                child: Text(
                                  "Upload Image",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              //showing image preview:
                              Container(
                                  child: file != null
                                      ? Text("Image Uploaded")
                                      : null),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                style: buttonStyle,
                                onPressed: register,
                                child: ListTile(
                                  textColor:
                                      Theme.of(context).colorScheme.secondary,
                                  iconColor:
                                      Theme.of(context).colorScheme.secondary,
                                  leading: Icon(Icons.login),
                                  title: const Text("Register",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text.rich(TextSpan(
                                text: "Already Have an Account? ",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Login",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
                                        }),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  uploadFromCamera() async {
    Navigator.pop(context);
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  register() async {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          final uid = _auth.currentUser!.uid;
          if (value != null) {
            helperFunction.userRef.doc(uid).set(
              {
                'email': email,
                'name': name,
                'phNumber': phNumber,
                'role': "client",
                'uid': uid,
                'address': address,
              },
            );
            helperFunction.clientRef.doc(uid).set(
              {
                'email': email,
                'name': name,
                'phNumber': phNumber,
                'role': "client",
                'uid': uid,
                'address': address,
              },
            );
            helperFunction.saveUserEmailStatus(email);
            helperFunction.saveUserLoggedInStatus(true);
            helperFunction.saveUserRole('client');
            helperFunction.saveUserName(name);

            helperFunction.saveUserUID(uid);

            NextScreen(
              context,
              mainPage(),
            );
          }
        });
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }
  }
}
