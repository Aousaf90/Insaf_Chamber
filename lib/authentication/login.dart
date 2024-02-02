import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/mainPage.dart';
import 'package:insafchamber/authentication/register.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';
import 'package:lottie/lottie.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final formKey = GlobalKey<FormState>();
  final profileImageRef = FirebaseStorage.instance.ref().child("profileImage");

  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String imageURL = "";
  String email = "";
  String password = "";
  String userRole = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.network(
                        "https://assets3.lottiefiles.com/packages/lf20_MbephoYReu.json",
                        height: 300,
                        width: 300,
                      ),
                      const SizedBox(height: 20),
                      //LOGIN CONTAINER
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
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  label: const Text("Enter your Email"),
                                ),
                                onChanged: (value) {
                    //               validator: (value) {
                    //   return EmailValidator.validate(value!)
                    //       ? null
                    //       : "Please enter a valid email";
                    // },
                                  setState(
                                    () {
                                      email = value;
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
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
                              const SizedBox(height: 40),
                              ElevatedButton(
                                style: buttonStyle,
                                onPressed: login,
                                child: ListTile(
                                  textColor:
                                      Theme.of(context).colorScheme.secondary,
                                  iconColor:
                                      Theme.of(context).colorScheme.secondary,
                                  leading: Icon(Icons.login),
                                  title: const Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Register here",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            NextScreen(context, registerUser());
                                          }),
                                  ],
                                ),
                              ),
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

  login() async {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: ((context) => Center(
              child: LottieBuilder.network(
                "https://assets4.lottiefiles.com/private_files/lf30_vut4pyyx.json",
                height: 50,
                width: 50,
              ),
            )),
      );

      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        Navigator.pop(context); // Dismiss the CircularProgressIndicator

        if (userCredential != null) {
          await helperFunction.userRef
              .where('uid', isEqualTo: userCredential.user!.uid)
              .get()
              .then(
            (snapshot) {
              snapshot.docs.forEach(
                (element) {
                  if (snapshot.docs == null) {
                    print("there is no data");
                  } else {
                    setState(
                      () {
                        name = element['name'];
                        userRole = element['role'];
                        // Update state here
                      },
                    );
                  }
                },
              );
            },
          );

          helperFunction.saveUserLoggedInStatus(true);
          helperFunction.saveUserEmailStatus(email);
          helperFunction.saveUserName(name);
          helperFunction.saveUserRole(userRole);

          NextScreen(context, mainPage());
        } else {
          showSnackbar(
            context,
            Theme.of(context).colorScheme.error,
            "Invalid email or password",
          );
        }
      } on FirebaseAuthException catch (e) {
        print(e);
        Navigator.pop(context); // Dismiss the CircularProgressIndicator
        showSnackbar(
          context,
          Theme.of(context).colorScheme.error,
          "Invalid email or password",
        );
      }
    }
  }
}
