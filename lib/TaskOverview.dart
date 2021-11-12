import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// Class for main homepage overview
class TaskOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskOverviewState();
  }
}

// Stateful class to build homepage overview
class TaskOverviewState extends State<TaskOverview> {
  final List<String> buttonEntries = ['Daily', 'Weekly', 'Monthly', 'General'];
  final List<String> textEntries = [];
  final ButtonStyle headerStyle = ElevatedButton.styleFrom(minimumSize: Size(0, 50));
  var currentUser = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    // Check if user can be accessed in different classes (Yes they can)
    if (currentUser != null) {
      print(currentUser!.uid);
    } else {
      print("User is null");
    }
    // initializeTestData();
    // retrieveTestData();
    return Scaffold(
      appBar: AppBar(
          title: Text('TaskMaster'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
          children: _buildCategories()
      ),
    );
  }
  // Builds a given category (primarily just the header)
  Widget _buildCategory(int i) {
    return AppBar(
      title: Text(buttonEntries[i]),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.access_alarm),
            tooltip: 'Click here',
            onPressed: () => Navigator.pushNamed(context, "categoryDetails")
        ),
      ],
    );
  }

  // Builds the tasks in a given category using ReorderableListView.
  Widget _buildTasks() {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Snapshot error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading');
        }

        return ReorderableListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              for (int i = 0; i < textEntries.length; i++)
                Card(
                    key: Key('$i'),
                    child: ListTile(
                    trailing: Transform(
                      transform: Matrix4.translationValues(16, 0.0, 0.0),
                      child: IconButton(
                            icon: Icon(Icons.add),
                            tooltip: 'More details',
                            onPressed: () => Navigator.pushNamed(context, "categoryDetails")
                      ),
                    ),
                    title: Text(textEntries[i]),
                  )
                )
            ],
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = textEntries.removeAt(oldIndex);
                textEntries.insert(newIndex, item);
              });
            }
        );
      }
    );
  }

  // Builds the categories of the home page.
  List<Widget> _buildCategories() {
    var list = <Widget>[];
    for (int i = 0; i < buttonEntries.length; i++) {
      list.add(_buildCategory(i));
      list.add(_buildTasks());
    }
    return list;
  }
}
