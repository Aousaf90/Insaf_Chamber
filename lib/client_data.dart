import 'package:firebase_auth/firebase_auth.dart';
import 'package:insafchamber/Pages/clientside_pages/searchPage.dart';

import 'Pages/clientside_pages/caseManagement.dart';
import 'Pages/clientside_pages/chatList.dart';
import 'Pages/clientside_pages/home.dart';
import 'Pages/clientside_pages/profile.dart';

class clientData {
  final _auth = FirebaseAuth.instance;

  String email = "";
  String uid = "";
  clientData() {
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

  //client Pages
  List clientPages = [
    homePage(),
    caseManagement(),
    searchPage(),
    chatRoomList(),
    profilePage(),
  ];
  checkOutclientPage(int index) {
    return clientPages[index];
  }
}
