import 'package:flutter/material.dart';

import 'models/dog.dart';

import 'widgets/dog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We Rate Dogs',
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

  Future<Dog> _showNewDogForm() async {
    Dog newDog = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return AddDogFormPage();
        }
      )
    );
    if (newDog != null) initialDoggos.add(newDog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black87,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showNewDogForm
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops : [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.indigo[800],
              Colors.indigo[700],
              Colors.indigo[600],
              Colors.indigo[400]
            ]
          )
        ),
        child: Center(
          child: DogListWidget(initialDoggos),
        )
      )
    );
  }
}
