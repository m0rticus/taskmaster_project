import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'TaskDetails.dart';
import 'TaskOverview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// Stateful class for app
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

// Stateful class to build app
// Primarily for routing
class MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Authentication
    initializeAuth();
    createAccAuth();
    signInAccAuth();

    // Stateful loading for FlutterFire initialization
    if (_error) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                  title: Text("Error")
              )
          )
      );
    }
    if (!_initialized) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                  title: Text("Loading")
              )
          )
      );
    }
    return MaterialApp(
        home: TaskOverview(),
        routes: {
          'categoryDetails': (context) => TaskDetails()
        }
    );
  }
  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void initializeAuth() async {
    auth.authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('Signed out');
      } else {
        print('Signed in');
      }
    });
  }

  void createAccAuth() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword (
          email: "bobchu351@gmail.com",
          password: "1234567"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'fail condition') {
        print('Auth failure');
      } else if (e.code == 'email-already-in-use') {
        print('Account already exists for that email');
      }
    } catch (e) {
      print(e);
    }
  }

  void signInAccAuth() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: "bobchu351@gmail.com",
          password: "1234567"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('User not found');
      } else if (e.code == 'wrong-password') {
        print('Wrong password');
      }
    } catch (e) {
      print(e);
    }
  }

}
