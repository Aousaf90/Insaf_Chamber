import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/clientside_pages/caseManagement.dart';
import 'package:insafchamber/Pages/clientside_pages/home.dart';
import 'package:insafchamber/Pages/clientside_pages/profile.dart';
import 'package:insafchamber/authentication/login.dart';
import 'package:insafchamber/client_data.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/lawyer_Data.dart';
import 'package:insafchamber/widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);
  @override
  _mainPageState createState() => _mainPageState();
}
lawyerData lData = lawyerData();
clientData cData = clientData();
bool isLawyer = false;
final _auth = FirebaseAuth.instance;
String fieldTime = "";
String Speciality = "";
String city = "";
String userEmail = "";
String userName = "";
String userAddress = "";
String userPhNumber = "";

int _selectedTab = 0;

class _mainPageState extends State<mainPage> {
  _onchangeTab(int index) {
    setState(
      () {
        _selectedTab = index;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();

    helperFunction.getUserRoleStatus().then(
      (value) {
        print(value);
        if (value == "Lawyer")
          setState(
            () {
              isLawyer = true;
            },
          );
      },
    );
    helperFunction.getUsernameStatus().then((value) => print(value));
    super.initState();
  }

//main WidgetBuilder
//checking lawyer status
//
  @override
  Widget build(BuildContext context) {
    return isLawyer ? lawyserSidePae() : clientSidePage();
  }

  //Functions
  logout() async {
    try {
      await _auth.signOut();

      NextScreen(context, loginPage());

      helperFunction.saveUserEmailStatus("Null");
      helperFunction.saveUserLoggedInStatus(false);
      isLawyer = false;
      helperFunction.saveUserUID("Null");
      helperFunction.saveUserName("Null");
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  getUserData() async {
    try {
      await helperFunction.getUserEmailStats().then((value) {
        setState(
          () {
            userEmail = value!;
          },
        );
      });
      await helperFunction.userRef
          .where('email', isEqualTo: userEmail)
          .get()
          .then((snapshot) {
        try {
          snapshot.docs.forEach((docs) {
            setState(() {
              userName = docs['name'];
              userPhNumber = docs['phNumber'];
              userAddress = docs['address'];
            });
          });
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Widget lawyserSidePae() {
    return Scaffold(
      appBar: AppBar(title: Text(lawyerData().lawyerPageName[_selectedTab])),
      drawer: Drawer(
        child: ListView(
          children: [
            LottieBuilder.network(
              "https://assets7.lottiefiles.com/packages/lf20_cz6ukw4q.json",
              height: 130,
              width: 130,
            ),

            //User Name
            ListTile(
              leading: Icon(Icons.person),
              title: Text(userName),
            ),
            //User Email
            ListTile(
              leading: Icon(Icons.email),
              title: Text(userEmail),
            ),
            const SizedBox(height: 100),
            //logout ListTile
            ListTile(
              onTap: logout,
              leading: Icon(Icons.logout),
              title: const Text(
                "Logout",
              ),
            )
          ],
        ),
      ),
      body: lData.checkOutPage(_selectedTab),
      //_pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedIconTheme: IconThemeData(size: 40, color: seccondaryColor),
        useLegacyColorScheme: false,
        showUnselectedLabels: true,
        showSelectedLabels: false,
        onTap: (index) => _onchangeTab(index),
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_rounded), label: " Case Management"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Request Page"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat App"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget clientSidePage() {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            LottieBuilder.network(
              "https://assets7.lottiefiles.com/packages/lf20_cz6ukw4q.json",
              height: 130,
              width: 130,
            ),
            //User Name
            ListTile(
              leading: Icon(Icons.person),
              title: Text(userName),
            ),
            //User Email
            ListTile(
              leading: Icon(Icons.email),
              title: Text(userEmail),
            ),
            const SizedBox(height: 100),
            //logout ListTile
            ListTile(
              onTap: logout,
              leading: Icon(Icons.logout),
              title: const Text(
                "Logout",
              ),
            )
          ],
        ),
      ),
      body: cData.checkOutclientPage(_selectedTab),
      //_pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(
            size: 40, color: Theme.of(context).colorScheme.onBackground),
        useLegacyColorScheme: false,
        showUnselectedLabels: true,
        showSelectedLabels: false,
        onTap: (index) => _onchangeTab(index),
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_rounded), label: " Management"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat App"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
