import 'package:flutter/material.dart';

import 'models/dog.dart';

import 'widgets/dog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We Hate Dogs',
      theme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(title: 'We Rate Dogs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<Dog> initialDoggos = []
    ..add(Dog(name: 'Joelma', description: 'Joelma is a good girl!', location: 'Portland, OR, USA'))
    ..add(Dog(name: 'Anastacio', description: 'Anastacio is a lazy dog!', location: 'Pindamonhangaba, SP, BRA'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        child: DogListWidget(initialDoggos),
      )
    );
  }
}
