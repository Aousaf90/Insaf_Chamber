import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/case_folder/activeCase.dart';
import 'package:insafchamber/Pages/lawyerSide_pages/profile.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class modifyHistoryClass extends StatefulWidget {
  String lawyerEmail;
  String clientEmail;
  String title;

  modifyHistoryClass(
      {required this.clientEmail,
      required this.lawyerEmail,
      required this.title});

  //Additional Info
  @override
  _modifyHistoryClassState createState() => _modifyHistoryClassState();
}

String clientPhoneNumber = "";
String description = "";
List witnessList = [
  const Text("1: Aousaf Sulaman"),
  const Text("2: Nouman Sulaman"),
  const Text("2: Imran Khan"),
  const Text("2: Zeerak Zahid"),
  const Text("2: Messi"),
];

class _modifyHistoryClassState extends State<modifyHistoryClass> {
  @override
  void initState() {
    getClientInfo();
    // TODO: implement initState

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: "Date:     ",
                  style: subHeadingStyle.copyWith(fontSize: 26),
                  children: [
                    TextSpan(
                      text: DateTime.now().toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 3,
              ),
              const SizedBox(height: 20),
              const Text(
                "Description of Event:",
                style: subHeadingStyle,
              ),
              TextFormField(
                onSaved: (newValue) {
                  setState(() {
                    description = newValue.toString();
                  });
                },
                decoration: InputDecoration(
                  labelText: "Description of Event",
                ),
              ),
              Divider(
                thickness: 2,
              ),
              const SizedBox(height: 20),
              const Text(
                "Communication Record",
                style: subHeadingStyle,
              ),
              ListTile(
                iconColor: primaryColor,
                textColor: primaryColor,
                leading: Icon(Icons.email),
                title: Text(
                  "Email",
                  style: subHeadingStyle.copyWith(fontSize: 15),
                ),
                trailing: Text(widget.clientEmail),
              ),
              Divider(),
              ListTile(
                iconColor: Colors.black,
                textColor: Colors.black,
                leading: Icon(Icons.phone),
                title: Text(
                  "Phone",
                  style: subHeadingStyle.copyWith(fontSize: 15),
                ),
                trailing: Text(clientPhoneNumber),
              ),
              SizedBox(
                height: 20,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  //File Management Box
                  fileManagementWidget(),
                  SizedBox(width: 10),
                  //Witness Box
                  witnessBoxWidget(),
                ],
              ), // Add additional spacing at the end if needed
              Center(
                child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    addEvent();
                  },
                  child: Text("Add Log"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addEvent() async {
    try {
      final ref = await helperFunction.caseRef
          .where('title', isEqualTo: widget.title)
          .get();
      final docRef = ref.docs.first.reference
          .collection("history")
          .doc(DateTime.now().toString())
          .set({
        "date": DateTime.now().toString(),
        "description": description,
        "email": widget.clientEmail,
        "phNumber": "03446851290",
        "witnessList": witnessList
      }).then((value) {
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    }
  }

  getClientInfo() async {
    try {
      await helperFunction.caseRef
          .where("email", isEqualTo: widget.clientEmail)
          .get()
          .then(
        (value) {
          value.docs.forEach(
            (element) {
              setState(
                () {
                  clientPhoneNumber = element["phNumber"];
                  print(clientPhoneNumber);
                },
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
}

class fileManagementWidget extends StatelessWidget {
  const fileManagementWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: primaryColor,
        ),
        height: 200,
        child: Center(
          child: Column(
            children: [
              Text(
                "File Management",
                style: TextStyle(
                  color: seccondaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class witnessBoxWidget extends StatelessWidget {
  const witnessBoxWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: primaryColor,
        ),
        height: 200,
        child: Center(
          child: Column(
            children: [
              Text(
                "Witness & Testimonies ",
                style: TextStyle(
                  color: seccondaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "1: Aousaf Sulaman",
                    style: TextStyle(
                      color: seccondaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "2: Nouman Sulaman",
                    style: TextStyle(
                      color: seccondaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "3: Imran Khan",
                    style: TextStyle(
                      color: seccondaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "4: Zeerak Zahid",
                    style: TextStyle(
                      color: seccondaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "5: Messi",
                    style: TextStyle(
                      color: seccondaryColor,
                    ),
                  ),
                ],
              )),
              TextButton(
                onPressed: () {},
                child: Icon(
                  Icons.add,
                  color: seccondaryColor,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
