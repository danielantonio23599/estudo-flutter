
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxo/controle/CTipoReceitas.dart';
import 'package:fluxo/modelo/beans/tipoReceita.dart';

class CadTipoReceita extends StatefulWidget {

  @override
  _CadTipoReceitaState createState() => _CadTipoReceitaState();
}

class _CadTipoReceitaState extends State<CadTipoReceita> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tipo de Receita"),
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
                      onPressed: () { _insereTipoReceita();},
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
              child: ListView(children: _listViewTipoReceita),
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
  List<TipoReceita> _tiposResceita = [];

  //listView de tipos de gastos
  List<Widget> _listViewTipoReceita = [];

  /**
   * Método responsável por construir o listview
   */
  _setListView() async {
    //busca lista de objetos Gasto do BD
    _tiposResceita = await CTipoReceita().getAllList();

    //monta listView já na treade de visualização de forma dinâmica
    setState(() {
      try {
        _listViewTipoReceita = _tiposResceita
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
                          onPressed: () { _deleteTipoReceita(_data.id!);},
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

  _insereTipoReceita() {
    TipoReceita g = TipoReceita(null, _tecNome.text, _tecDescricao.text);
    CTipoReceita().insert(g);
    setState(() {
      _setListView();
    });
  }

  _deleteTipoReceita(int id){
    CTipoReceita().deletar(id);
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