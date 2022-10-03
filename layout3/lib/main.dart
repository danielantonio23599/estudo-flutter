import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout3/navegar.dart';

Future<void> main() async {
  runApp(MaterialApp( //materialApp pq vamos usar widgets material design
      title: "Layout", //titulo da aplicação
      home: Navegar(0) // chamei o login
  ));

}
