import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class helperFunction {
  static List requestStatus = ["pending", "negotiation", "deal"];
  static String emailKey = "emailKey";
  static String imageURL = "URL";
  static String nameKey = "nameKey";
  static String loginStatus = "loginKey";
  static String userUID = "userKey";
  static String userRole = "userRole";
  //saving logedIN status
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(loginStatus, isUserLoggedIn);
  }

  //saving UserName
  static Future<bool> saveUserName(String name) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(nameKey, name);
  }

  //saving profileImage
  static Future<bool> savingprofileImage(String profileImage) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(imageURL, profileImage);
  }

  //saving userUID
  static Future<bool> saveUserUID(String uid) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userUID, uid);
  }

  //saving userEmail
  static Future<bool> saveUserEmailStatus(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(emailKey, email);
  }

  //saving user Role
  static Future<bool> saveUserRole(String Role) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userRole, Role);
  }

/*===============================================================
================================================================= */
  //gettign user LogIN Status
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(loginStatus);
  }

  //getting user Email
  static Future<String?> getUserEmailStats() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(emailKey);
  }

//getting user Role
  static Future<String?> getUserRoleStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(userRole);
  }

//getting user Name
  static Future<String?> getUsernameStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(nameKey);
  }

//getting ImageURL
  static Future<String?> getprofileImage() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.getString(imageURL);
  }

  //getting user UID
  static Future<String?> getUserUidStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.getString(userUID);
  }

  /** =================================================
 * References of Firestore and Auth 
 * ==================================================d
 * ==================================================l*/
  static final _auth = FirebaseAuth.instance.currentUser;

  static final lawyerRef = FirebaseFirestore.instance.collection("Lawyer");

  static final userRef = FirebaseFirestore.instance.collection("users");
  static final caseRef = FirebaseFirestore.instance.collection("case");

  static final messageRef = FirebaseFirestore.instance.collection("messages");
  static final clientRef = FirebaseFirestore.instance.collection("Client");
  static final requestRef = FirebaseFirestore.instance.collection("requests");
  static final storageRef = FirebaseStorage.instance;
}
