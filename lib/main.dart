import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:insafchamber/authentication/login.dart';
import 'package:insafchamber/helpterFunctions.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Pages/mainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 53, 52, 52),
          onPrimary: Color.fromARGB(255, 121, 120, 120),
          secondary: Color.fromARGB(255, 201, 191, 191),
          onSecondary: Color.fromARGB(255, 175, 172, 172),
          error: Color.fromARGB(255, 255, 1, 1),
          onError: Color.fromARGB(255, 109, 16, 16),
          background: Color.fromARGB(255, 19, 19, 19),
          onBackground: Color.fromARGB(255, 49, 48, 48),
          surface: Color.fromARGB(255, 255, 255, 255),
          onSurface: Color.fromARGB(255, 255, 252, 252),
        ),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoggedIn = false;
  late Future<bool> _firebaseInitialized;

  @override
  void initState() {
    _firebaseInitialized = initializeFirebase();
    getLoggedInStatus();
    super.initState();
  }

  Future<bool> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      return true;
    } catch (e) {
      print('Failed to initialize Firebase: $e');
      return false;
    }
  }

  void getLoggedInStatus() {
    helperFunction.getUserLoggedInStatus().then((value) {
      setState(() {
        if (value != null) {
          _isLoggedIn = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _firebaseInitialized,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Failed to initialize Firebase'),
          );
        } else {
          return _isLoggedIn ? mainPage() : loginPage();
        }
      },
    );
  }
}
