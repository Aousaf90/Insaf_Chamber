import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/mainPage.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/lawyer_Data.dart';
import 'package:insafchamber/widget.dart';

class profilePage extends StatefulWidget {
  @override
  State<profilePage> createState() => _profilePageState();
}

final lawyerRef = FirebaseFirestore.instance.collection("Lawyer");
//dumy Data
String userEmail = "furqansulaman@gmail.com";
String userName = "Furqan Sulaman";
String phNumber = "03000023590";
String address = "435-G Shahrukn-alam Colony Multan";
String userSpeciality = "Tax";
String userTimeInField = "10 Year";

class _profilePageState extends State<profilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 800,
      decoration: BoxDecoration(
        image: DecorationImage(
          opacity: 0.5,
          image: AssetImage("images/courtRoom.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //main container
          Container(
              child: Stack(
            clipBehavior: Clip.none,
            children: [
              //profile Information
              Container(
                width: double.infinity,
                height: 450,
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.softLight,
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 60),
                    listTileView(
                      leadingIcon: Icon(Icons.email),
                      value: userEmail,
                      trailingIcon: Icon(Icons.edit),
                    ),
                    listTileView(
                      leadingIcon: Icon(Icons.phone),
                      value: userPhNumber,
                      trailingIcon: Icon(Icons.edit),
                    ),
                    listTileView(
                      leadingIcon: Icon(Icons.house),
                      value: address,
                      trailingIcon: Icon(Icons.edit),
                    ),
                    listTileView(
                      leadingIcon: Icon(Icons.punch_clock),
                      value: "Field Time " + userTimeInField,
                      trailingIcon:
                          Icon(Icons.wifi_tethering_error_rounded_outlined),
                    ),
                    const SizedBox(height: 20),
                    //logout button and reset password button
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {},
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 100),
                          leading: Icon(Icons.logout, color: Colors.white),
                          title: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
//change password
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {},
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 70),
                          leading:
                              Icon(Icons.password_sharp, color: Colors.white),
                          title: Text(
                            "Change Password",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //name and other Information
              Positioned(
                child: Container(
                  padding: EdgeInsets.fromLTRB(170, 0, 0, 0),
                  child: ListTile(
                    title: Text(userName),
                    subtitle: Text(userSpeciality + "  Domain"),
                  ),
                ),
              ),
              //circular avatar
              Positioned(
                left: 50,
                bottom: 390,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  // getUserData() {
  //   lawyerRef.where('uid', isEqualTo: widget.uid).get().then((value) {
  //     value.docs.forEach((element) {
  //       setState(() {
  //         name = element['name'];
  //         phNumber = element['phNumber'];
  //       });
  //     });
  //   });
  // }
}

class listTileView extends StatelessWidget {
  String value;
  Icon leadingIcon;
  Icon trailingIcon;
  listTileView(
      {required this.leadingIcon,
      required this.value,
      required this.trailingIcon});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: Theme.of(context).colorScheme.primary,
      leading: leadingIcon,
      title: Text(value),
      //callback to the selected icon
      trailing: IconButton(onPressed: () {}, icon: trailingIcon),
    );
  }
}
