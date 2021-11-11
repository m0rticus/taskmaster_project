import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

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
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              home: TaskOverview(),
              routes: {
                'categoryDetails': (context) => TaskDetails()
              }
          );
        }
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text("Loading")
            )
          )
        );
      }
    );
  }
}

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
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    initializeTestData();
    retrieveTestData();
    return Scaffold(
        appBar: AppBar(
          title: Text('TaskMaster')
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
  // TODO fix the alignment of the iconbutton
  Widget _buildTasks() {
    return ReorderableListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          for (int i = 0; i < textEntries.length; i++)
            ListTile(
              key: Key('$i'),
              trailing: IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'More details',
                  onPressed: () => Navigator.pushNamed(context, "categoryDetails")
              ),
              title: Text(textEntries[i]),
            ),
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

  // Builds the categories of the home page.
  List<Widget> _buildCategories() {
    var list = <Widget>[];
    for (int i = 0; i < buttonEntries.length; i++) {
      list.add(_buildCategory(i));
      list.add(_buildTasks());
    }
    return list;
  }

  void initializeTestData() {
    for (int i = 1; i <= 5; i++) {
      firestoreInstance.collection("tasks").add({
        "name" : "test" + "$i",
        "details" : {
          "foo" : "bar"
        }
      });
    }
  }

  void retrieveTestData() {
    firestoreInstance.collection("tasks").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        textEntries.add(result.data()["name"]);
      });
    });
  }
}

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