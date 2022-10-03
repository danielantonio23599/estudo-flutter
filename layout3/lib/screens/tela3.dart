import 'dart:async';

import 'package:flutter/material.dart';
import 'package:layout3/navegar.dart';

class Tela3 extends StatefulWidget {
  @override
  _Tela3State createState() => _Tela3State();
}

class _Tela3State extends State<Tela3> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              setState(() {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navegar(0)));
              });
            },
          ),
        ],
      ),
      body: Center(child: Text('XXX'),),
      backgroundColor: Colors.black12,
    );
  }
}
