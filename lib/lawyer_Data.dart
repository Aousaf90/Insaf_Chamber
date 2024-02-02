import 'package:firebase_auth/firebase_auth.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/case_folder/caseManagement.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/home.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/messages.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/profile.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/reminders.dart';
import 'package:insafchamber/client_data.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:flutter/material.dart';

class lawyerData extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  static List<Widget> clientList = [];
  String email = "";
  String uid = "";
  lawyerData() {
    email = _auth.currentUser!.email.toString();
    uid = _auth.currentUser!.uid;
  }
  String getUID() {
    //personal data
    String uid = "";
    uid = _auth.currentUser!.uid;
    return uid;
  }

  String getEmail() {
    final _auth = FirebaseAuth.instance;
    //personal data
    String email = "";
    email = _auth.currentUser!.email.toString();
    return email;
  }

  List getClientList() {
    return clientList;
  }

  final List lawyerPages = [
    homePage(),
    caseManagementPage(),
    ReminderPage(),
    messagesPage(),
    profilePage(),
  ];
  //page route
  List lawyerPageName = [
    "Home Page",
    "Case Management",
    "Reminder Page",
    "Chat Room",
    "Profile",
  ];

  checkOutPage(int index) {
    return lawyerPages[index];
  }
}
