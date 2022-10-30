
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CadGasto extends StatefulWidget {

  @override
  _CadGastoState createState() => _CadGastoState();
}

class _CadGastoState extends State<CadGasto> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cad. Gastos"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: <Widget>[
          //card para inserção
          Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Tipo de Gasto:"),
                      //DropdownButton(onChanged: (value) {  }, items: [],),
                      Text("Observações:"),
                      TextField(),
                      Text("Valor:"),
                      TextField(),
                      Row(children: <Widget>[
                        Expanded(child: Column(children: <Widget>[
                          Text("Data:"),
                          TextField(),
                        ],),),
                        Expanded(child: Column(children: <Widget>[
                          Text("Hora:"),
                          TextField(),
                        ],),)
                      ],),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  child: ButtonTheme(
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Card(
              child: ListView(),
            ),
          )
        ],
      )
    );
  }
}