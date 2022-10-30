import 'package:flutter/material.dart';
import 'package:fluxo/splash.dart';

void main() {
  // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();



  runApp(MaterialApp(
      title: "Fluxo Caixa",
      home: Splash()
  ));

}