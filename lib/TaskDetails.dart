import 'dart:ui';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Class for more task details page
class TaskDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskDetailsState();
  }
}

// Class to build task details page
class TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task'),
        )
    );
  }
}