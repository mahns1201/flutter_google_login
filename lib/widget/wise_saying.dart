import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WiseSaying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wise Saying',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white),
      home: Scaffold(
        body: Container(
          child: Center(child: MyLayout()),
        ),
      ),
    );
  }
}

class MyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        color: Colors.black,
        child: Text('오늘의 명언 보기'),
        onPressed: () {
          showAlertDialog(context);
        },
      ),
    );
  }
}

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("네."),
    onPressed: () => Navigator.pop(context),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("명언"),
    content: StreamBuilder(
      stream: Firestore.instance.collection('wise-saying').snapshots(),
      builder: (context, snapshot){
        if (! snapshot.hasData) return Text("Loading data...");
        return Text(snapshot.data.documents[0]['today']);
      }
    ),
    actions: [
      okButton,
    ],
    backgroundColor: Colors.blueGrey,
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}