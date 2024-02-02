import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insafchamber/Pages/clientside_pages/sendRequest.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:insafchamber/widget.dart';

class searchPage extends StatefulWidget {
  const searchPage({Key? key}) : super(key: key);

  @override
  _searchPageState createState() => _searchPageState();
}

final lawyerRef = helperFunction.lawyerRef;
String searchValue = "";
final _auth = FirebaseAuth.instance;
String email = _auth.currentUser!.email.toString();

class _searchPageState extends State<searchPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        backgroundColor: Colors.white,
        title: TextFormField(
          onChanged: (value) {
            setState(() {
              searchValue = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Search Lawyer",
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.cancel),
            ),
          ),
        ),
      ),
      body: Container(
          child: StreamBuilder(
        stream: lawyerRef
            .where('name', isGreaterThanOrEqualTo: searchValue)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final snap = snapshot.data!.docs;
          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context, index) {
              var data = snap[index].data();
              String lawyerEmail = snap[index]['email'];
              if (searchValue.isEmpty) {
                return listTileWidget(
                  data: data,
                  image: AssetImage("images/$lawyerEmail.jpeg"),
                );
              }
              if (data['name'].toString().toLowerCase().startsWith(
                    searchValue.toLowerCase(),
                  )) {
                return listTileWidget(
                  data: data,
                  image: AssetImage("images/$lawyerEmail.jpeg"),
                );
              }
              ;
            },
          );
        },
      )),
    );
  }
}

class listTileWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final image;
  listTileWidget({required this.data, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          width: 350,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
                opacity: 0.8,
              )),
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.black),
                trailing: IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                  onPressed: () {
                    NextScreen(
                      context,
                      sendRequestPage(
                        sendByUID: _auth.currentUser!.uid,
                        sendToUID: data["uid"],
                      ),
                    );
                  },
                ),
                title: Text(
                  data['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(data['Speciality'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Positioned(
                bottom: 70,
                right: 170,
                child: Text(
                  data["fieldTime"] + " Year in Field",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50)
      ],
    );
  }
}
