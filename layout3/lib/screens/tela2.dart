import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layout3/navegar.dart';


class Tela2 extends StatefulWidget {
  @override
  _Tela2State createState() => _Tela2State();
}

class _Tela2State extends State<Tela2> {
  /**
   * Método de inicialização da tela
   */
  @override
  void initState() {
    super.initState();
  }

  /**
   * método que monta a tela de informativo
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações Gerais'),
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Navegar(0)));
            },
          ),
        ],
      ),

      //corpo da aplicação, aqui são setadas as telas
      body: Text("Texto Tela2 o aplicativo"),
      backgroundColor: Colors.white,
    );
  }
}
