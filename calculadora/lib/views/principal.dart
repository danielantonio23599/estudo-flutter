
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

final styleLabel  = TextStyle(color: Colors.black,fontSize: 16);

class Principal extends StatefulWidget{
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: Center(
        child: Column(children: <Widget>[
          Padding(padding: EdgeInsets.all(30), child: Text("Calculadora", style: styleLabel)),
          Column(
              children: [
                Padding(padding: EdgeInsets.only(left: 10) , child: Text("Valor 1:", style: styleLabel)),
                Padding(padding: EdgeInsets.only(left: 10), child: TextField(controller: _v1,),),
              ], crossAxisAlignment: CrossAxisAlignment.start
          ),
          Column(
              children: [
                Padding(padding: EdgeInsets.only(left: 10,top: 20) , child: Text("Valor 2:", style: styleLabel)),
                Padding(padding: EdgeInsets.only(left: 10), child: TextField(controller: _v2,),),
              ], crossAxisAlignment: CrossAxisAlignment.start
          ),
          Row(children: [
            Expanded(flex: 2, child: botao(' + ',_eventoBotaoSomar)),
            Expanded(flex: 2, child:botao(' - ',_eventoBotaoSubtrair)),
            Expanded(flex: 2, child: botao(' * ',_eventoBotaoMult)),
            Expanded(flex: 2, child:botao(' / ',_eventoBotaoDiv)),
            Expanded(flex: 2, child:botao(' ^ ',_eventoBotaoEx))
          ]),
          Padding(padding: EdgeInsets.only(left: 10,top: 20) , child: Text("Total = $_total", style: styleLabel)),
        ],),
      ),
    );
  }

  Widget botao(String texto, Function acao){
    return
      Padding(padding: EdgeInsets.all(10), child: ButtonTheme(
        height: 60,
        child: TextButton (
          onPressed: (){acao();},
          child: Text(texto, style: TextStyle(color: Colors.black,fontSize: 14),),
        ),),);
  }
  TextEditingController _v1 = new TextEditingController();
  TextEditingController _v2 = new TextEditingController();
  double _total = 0;
  double _vf1 = 0;
  double _vf2 = 0;

  _obterValores(){
    if (_v1.text !=null && _v1.text.isNotEmpty) {
      _vf1 = double.parse(_v1.text);
    }
    if (_v2.text != null && _v2.text.isNotEmpty){
      _vf2 = double.parse(_v2.text);
    }
  }

  _eventoBotaoSomar(){
    setState(() {
      this._obterValores();
      _total = _vf1 + _vf2;
    });
  }

  _eventoBotaoSubtrair(){
    setState(() {
      this._obterValores();
      _total = _vf1 - _vf2;
    });
  }

  _eventoBotaoMult(){
    setState(() {
      this._obterValores();
      _total = _vf1 * _vf2;
    });
  }

  _eventoBotaoDiv(){
    setState(() {
      this._obterValores();
      _total = _vf1 / _vf2;
    });
  }

  _eventoBotaoEx(){
    setState(() {
      this._obterValores();
      _total = _vf1;
      for(var i = 1; i < _vf2 ; i++ ){
        _total *= _vf1;
      }
    });
  }
}