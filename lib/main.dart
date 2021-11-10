import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  final List<String> buttonEntries = ['Daily', 'Weekly', 'Monthly', 'General'];
  final List<String> textEntries = ['Task 1', 'Task 2', 'Task 3', 'Task 4', 'Task 5'];
  final ButtonStyle headerStyle = ElevatedButton.styleFrom(minimumSize: Size(0, 50));
  var index = 0;

  void printHello() {
    setState(() {
      index += 1;
    });
    print('Button 3 was pressed');
    print(index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('TaskMaster')),
        backgroundColor: Colors.white,
        body: ListView(
          children: _buildCategories()
        ),
      ),
    );
  }
  Widget _buildCategory(int i) {
    return AppBar(
      title: Text(buttonEntries[i] + ' $index'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.access_alarm),
            tooltip: 'Click here',
            onPressed: () => print('nice')
        ),
      ],
    );
  }
  Widget _buildTasks() {
    return ReorderableListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          for (int i = 0; i < textEntries.length; i++)
            ListTile(
              key: Key('$i'),
              trailing: Icon(Icons.agriculture_rounded),
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
  List<Widget> _buildCategories() {
    var list = <Widget>[];
    for (int i = 0; i < buttonEntries.length; i++) {
      list.add(_buildCategory(i));
      list.add(_buildTasks());
    }
    return list;
  }
}
