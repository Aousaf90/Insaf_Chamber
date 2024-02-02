import 'package:flutter/material.dart';

const headingStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 226, 225, 225),
);
const subHeadingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 19, 19, 19));
const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 121, 120, 120), width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 19, 19, 19), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 255, 1, 1), width: 2),
  ),
);
final buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return Color.fromARGB(255, 19, 19, 19);
      }
      return Color.fromARGB(255, 19, 19, 19);
    },
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  minimumSize: MaterialStateProperty.all(
    Size(40, 40),
  ),
);
final primaryColor = Color.fromRGBO(55, 52, 53, 1);
final seccondaryColor = Color.fromARGB(255, 214, 213, 210);
final flexColor = Color.fromARGB(255, 0, 0, 0);
NextScreen(context, PageRoute) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: ((context) => PageRoute),
    ),
  );
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}
