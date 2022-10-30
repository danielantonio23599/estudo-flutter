import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluxo/controle/CTipoGasto.dart';
import 'package:fluxo/modelo/beans/tipoGasto.dart';

class CadTipoGasto extends StatefulWidget {
  @override
  _CadTipoGastoState createState() => _CadTipoGastoState();
}

class _CadTipoGastoState extends State<CadTipoGasto> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tipo de Gasto"),
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
                      Text("Nome:"),
                      TextField(
                        controller: _tecNome,
                      ),
                      Text("Descrição:"),
                      TextField(
                        controller: _tecDescricao,
                      )
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () { _insereTipoGasto();},
                    child:  Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                )
              ],
            ),
          ),
          Divider(height: 10,),
          Text("::Dados::"),
          Expanded(
            child: Card(
              child: ListView(children: _listViewTipoGasto),
            ),
          )
        ],
      ),
    );
  }

  //controllers dos texts fields
  TextEditingController _tecNome = TextEditingController();
  TextEditingController _tecDescricao = TextEditingController();

  //lista de tipo de gastos
  List<TipoGasto> _tiposGasto = [];

  //listView de tipos de gastos
  List<Widget> _listViewTipoGasto = [];

  /**
   * Método responsável por construir o listview
   */
  _setListView() async {
    //busca lista de objetos Gasto do BD
    _tiposGasto = await CTipoGastos().getAllList();

    //monta listView já na treade de visualização de forma dinâmica
    setState(() {
      try {
        _listViewTipoGasto = _tiposGasto
            .map(
              (_data) => Card(
                  elevation: 3,
                  child: Container(
                    height: 35,
                    child: Row(
                      children: <Widget>[
                        Expanded(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Text(
                              _data.nome.toString(),
                              style: TextStyle(fontSize: 14,color: Colors.black),
                            ),
                            Text(
                              _data.descricao.toString(),
                              style: TextStyle(fontSize: 10,color: Colors.black45),
                            ),
                          ],),),
                        ButtonTheme(
                          height: 60.0,
                          child:
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () { _deleteTipoGasto(_data.id!);},
                            child:  Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          )
                        )
                      ],
                    ),
                  )),
            )
            .toList();
      } catch (_) {
        print("Não foi possível adicionar ao carrinho!");
        /*Toast.show("Não foi possível adicionar ao carrinho!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);*/
      }
    });
  }

  _insereTipoGasto() {
    TipoGasto g = TipoGasto(null, _tecNome.text, _tecDescricao.text);
    CTipoGastos().insert(g);
    setState(() {
      _setListView();
    });
  }

  _deleteTipoGasto(int id){
    CTipoGastos().deletar(id);
    setState(() {
      _setListView();
    });
  }

  /**
   * Método usado para inicialiar objetos e elementos ao criar a tela
   */
  @override
  void initState() {
    super.initState();

    //gera a listagem de elementos na thread de visão(de forma dinâmica)
    setState(() {
      _setListView();
    });
  }
}
