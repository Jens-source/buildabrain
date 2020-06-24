import 'package:flutter/material.dart';

class ClassSign extends StatefulWidget {
  @override
  _ClassSignState createState() => _ClassSignState();
}

class _ClassSignState extends State<ClassSign> {

  @override
  Widget build(BuildContext context) {
   return AlertDialog(
        title: Text('Rewind and remember'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('You will never be satisfied.'),
              Text('You\’re like me. I’m never satisfied.'),
            ],
          ),
        )
    );
  }

}