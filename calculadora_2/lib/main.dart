import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      home: const MyHomePage(title: 'Calculadora'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String? _texto = '0';
  late String? _operador = '0';
  late String? _operadorA = '0';
  double _num = 0;
  double _total = 0;

  void _concatDigitos(String str) {
    setState(() {
      if (_texto == '0')
        _texto = "$str";
      else
        _texto = "$_texto$str";
    });
  }

  void _sinalDigitos(String str) {
    setState(() {
      if (_texto == '0') {
        _texto = "$str";
      }
      if (_texto!.length > 0) {
        print(_texto!.substring(0 ,1));
        if(_texto!.substring(0 ,1) == "-"){
          _texto = _texto!.substring(1 ,_texto!.length);
        } else {
          _texto = "-$_texto";
        }
      }
    });
  }

  void _zeraDigitos(String str) {
    setState(() {
      _texto = "0";
      _operador = "0";
      _operadorA = "0";
      _total = 0;
      _num = 0;
    });
  }

  void _operacao(String str) {
    setState(() {
      _num = double.parse(_texto!);
      print(str);
      if(str == '%'){
        _calcula(str);
        _texto = '$_num';
        return;
      }
      else if(_operador !='0'){
        _calcula(_operador!);
      } else {
        _total = _num;
      }
      _operador = str;
      _texto = "0";
    });
  }

  void _calcula(String str) {
    setState(() {
      switch (str){
        case "+":
          _total += _num;
          break;
        case "-":
          _total -= _num;
          break;
        case "x":
          _total *= _num;
          break;
        case "/":
          _total /= _num;
          break;
        case "%":
          _num = _num/100;
          break;
      }
    });
  }
  void _igual(String str) {
    setState(() {
      if(_operador! != '0'){
        _num = double.parse(_texto!);
        _calcula(_operador!);
        _operadorA = _operador;
      }else{
        _calcula(_operadorA!);
      }
      _texto = "$_total";
      _operador = '0';
    });
  }
  void _removeDigitos(String str) {
    setState(() {
      if (_texto!.length > 0) {
        _texto = _texto!.substring(0 ,_texto!.length-1);
      }
      if (_texto == '')
        _texto = "0";
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget botaoB(String label,  Function funcao) {
      return
        Card(child:
        TextButton(
            onPressed: () { funcao(label);},
            child: Padding(padding: EdgeInsets.all(10), child:Text(label, style: TextStyle(color: Colors.black, fontSize: 30))),
            style: TextButton.styleFrom(shape: CircleBorder(), backgroundColor: Colors.black12, elevation: 1,shadowColor: Colors.black54)
        ),
          color: Color(0xffe8e8e0),
          shape: CircleBorder(),
        );
    }
    Widget botao(String label, Function funcao) {
      return
        Card(child:
        TextButton(
            onPressed: () { funcao(label);},
            child: Padding(padding: EdgeInsets.all(10), child:Text(label, style: TextStyle(color: Colors.white, fontSize: 30))),
            style: TextButton.styleFrom(shape: CircleBorder(), backgroundColor: Colors.black12, elevation: 1,shadowColor: Colors.black54)
        ),
          color: Colors.grey,
          shape: CircleBorder(),
        );
    }
    Widget botaoF(String label, Function funcao) {
      return
        Card(child:
        TextButton(
            onPressed: () { funcao(label);},
            child: Padding(padding: EdgeInsets.all(10), child:Text(label, style: TextStyle(color: Colors.white, fontSize: 30))),
            style: TextButton.styleFrom(shape: CircleBorder(), backgroundColor: Colors.black12, elevation: 1,shadowColor: Colors.black54)
        ),
          color: Colors.orange,
          shape: CircleBorder(),
        );
    }
    return Scaffold(

      body: Center(
          child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Padding(padding: EdgeInsets.only(top:80), child: Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [ Expanded(flex: 1, child:  Padding(padding: EdgeInsets.only(left:15, right: 15), child: Text('$_texto',textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 45))))],
                      ),
                      color: Colors.black,
                    )
                    )
                ),
                Expanded(flex: 4,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(flex: 2, child: botaoB("AC", _zeraDigitos)),
                            Expanded(flex: 2, child: botaoB("+/-", _sinalDigitos)),
                            Expanded(flex: 2, child: botaoB("%", _operacao)),
                            Expanded(flex: 2, child: botaoF("/", _operacao)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(flex: 2, child: botao("7", _concatDigitos)),
                            Expanded(flex: 2, child: botao("8", _concatDigitos)),
                            Expanded(flex: 2, child: botao("9", _concatDigitos)),
                            Expanded(flex: 2, child: botaoF("x", _operacao)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(flex: 2, child: botao("4", _concatDigitos)),
                            Expanded(flex: 2, child: botao("5", _concatDigitos)),
                            Expanded(flex: 2, child: botao("6", _concatDigitos)),
                            Expanded(flex: 2, child: botaoF("-", _operacao)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(flex: 2, child: botao("1", _concatDigitos)),
                            Expanded(flex: 2, child: botao("2", _concatDigitos)),
                            Expanded(flex: 2, child: botao("3", _concatDigitos)),
                            Expanded(flex: 2, child: botaoF("+", _operacao)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(flex: 2, child: botao("0", _concatDigitos)),
                            Expanded(flex: 2, child: botao("C", _removeDigitos)),
                            Expanded(flex: 2, child: botao(".", _concatDigitos)),
                            Expanded(flex: 2, child: botaoF("=", _igual)),
                          ],
                        ),
                      ],
                    ),
                    color: Colors.black,
                  ),
                )
              ]
          )
      ),
      backgroundColor: Colors.black,
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
