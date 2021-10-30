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
          children: <Widget>[
            ElevatedButton(
              style: headerStyle,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  buttonEntries[0],
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                )
              ),
              onPressed: () => print('Answer 1 chosen'),
            ),
            ElevatedButton(
              style: headerStyle,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    buttonEntries[1],
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  )
              ),
              onPressed: () {
                print('Answer 2 chosen');
              },
            ),
            ElevatedButton(
              style: headerStyle,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    buttonEntries[2] + ' $index',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  )
              ),
              onPressed: printHello,
            ),
          ],
        ),
      ),
    );
  }

}
