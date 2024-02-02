import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/requestInfo.dart';
import 'package:insafchamber/Pages/mainPage.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/lawyer_Data.dart';
import 'package:insafchamber/widget.dart';
import 'package:lottie/lottie.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

String userEmail = "";
String requestSendBY = "";
String clientEmail = "";
String clientUID = "";
String clientName = "";

class _homePageState extends State<homePage> {
  @override
  void initState() {
    helperFunction.getUserEmailStats().then(
      (value) {
        setState(
          () {
            userEmail = value.toString();
          },
        );
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/tarazoo.jpg"),
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                widgetListView(value: "News & UPdates"),
                const SizedBox(width: 40),
                widgetListView(value: "Alert Box"),
                const SizedBox(width: 40),
                Container(
                  decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.overlay,
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 200,
                  child: Center(
                    child: Text(
                      "Active Clients",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SearchBarAnimation(
            buttonShadowColour: primaryColor,
            textEditingController: textEditingController,
            isOriginalAnimation: false,
            trailingWidget: Icon(
              Icons.person,
            ),
            secondaryButtonWidget: Icon(Icons.cancel, color: primaryColor),
            buttonWidget: Icon(Icons.search, color: primaryColor),
          ),
          //search clients box
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: seccondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 400,
              child: StreamBuilder(
                stream: helperFunction.requestRef
                    .where(
                      "sendTo",
                      isEqualTo: userEmail,
                    )
                    .where("requestStage", isEqualTo: "pending")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final snap = snapshot.data!.docs;
                    if (snap != null) {
                      return ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          return RequestList(
                            snap: snap,
                            index: index,
                          );
                        },
                      );
                    }
                    return Text("No Data");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Shimmer(
                        direction: ShimmerDirection.fromLBRT(),
                        child: Container(),
                      ),
                    );
                  } else
                    return Container(
                      width: double.infinity,
                      child: Center(
                        child: LottieBuilder.network(
                          "https://assets2.lottiefiles.com/packages/lf20_th7LblsQX2.json",
                          height: 90,
                          width: 90,
                        ),
                      ),
                    );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

cancelReqest() async {}

class RequestList extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> snap;
  final int index;
  const RequestList({
    super.key,
    required this.snap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        try {
          NextScreen(
            context,
            requestInfo(
              snap: snap,
              index: index,
            ),
          );
        } catch (e) {
          print(e);
        }
      },
      trailing: IconButton(
        onPressed: () {
          cancelReqest();
        },
        icon: Icon(Icons.cancel),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.black,
      ),
      title: Text(
        requestSendBY = snap[index]["sendBy"],
      ),
      subtitle: Text(
        snap[index]["caseType"],
      ),
    );
  }
}

class searchResultListTile extends StatelessWidget {
  String value;
  Icon Iconvalue;

  searchResultListTile({required this.Iconvalue, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: primaryColor,
      textColor: primaryColor,
      title: Text(value),
      leading: Iconvalue,
      subtitle: Text("Tax Case"),
      trailing: Icon(Icons.message),
    );
  }
}

//news & updates, alert box, active clients
class widgetListView extends StatelessWidget {
  String value;
  widgetListView({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.overlay,
        color: flexColor,
        borderRadius: BorderRadius.circular(50),
      ),
      width: 200,
      child: Center(
        child: Text(
          value,
          style: TextStyle(color: seccondaryColor),
        ),
      ),
    );
  }
}
