import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  bool _initialized = false;
  bool _error = false;
  final String sampleEmail = "bobchu352@gmail.com";
  final String samplePassword = "1234567";

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Authentication
    initializeAuth();
    createAccAuth(sampleEmail, samplePassword);
    signInAccAuth(sampleEmail, samplePassword);

    // Stateful loading for FlutterFire initialization
    // Failed to initialize Firebase
    if (_error) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                  title: Text("Error")
              )
          )
      );
    }
    // Still loading Firebase
    if (!_initialized) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                  title: Text("Loading")
              )
          )
      );
    }
    // Initialized with no errors
    return MaterialApp(
        home: TaskOverview(),
        routes: {
          'categoryDetails': (context) => TaskDetails()
        }
    );
  }

  // Initialization function for Firebase
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

  // Checks whether the user has signed in state
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

  // Creates an account with sample parameters
  void createAccAuth(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword (
          email: email,
          password: password
      );
      await FirebaseFirestore.instance.collection('users')
        .doc(userCredential.user!.uid).set({
          'email' : email,
          'userId' : userCredential.user!.uid
      });
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

  // Attempts to sign in with sample parameters
  void signInAccAuth(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password
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
