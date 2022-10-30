import 'package:fluxo/modelo/beans/tipoReceita.dart';

import '../modelo/bd/bd_core.dart';

class CTipoReceita {
  Future<int> insert(TipoReceita g) async {
    int id = await BdCore.instance.insert(g.toMap(),BdCore.tableTipoReceita);
    print('linha inserida id: $id');
    return id;
  }
  Future<int> update(TipoReceita g) async {
    final linhasAfetadas = await BdCore.instance.update(g.toMap(),BdCore.tableTipoReceita);
    print('atualizadas $linhasAfetadas linha(s)');
    return linhasAfetadas;
  }
  Future<int> deletar(int id) async {
    final linhaDeletada = await BdCore.instance.delete(id, BdCore.tableTipoReceita);
    print('Deletada(s) $linhaDeletada linha(s): linha $id');
    return linhaDeletada;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final todasLinhas = await BdCore.instance.queryAllRows(BdCore.tableTipoReceita);
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) => print(row));
    return todasLinhas;
  }

  Future<List<TipoReceita>> getAllList() async {
    final todasLinhas = await BdCore.instance.queryAllRows(BdCore.tableTipoReceita);
    List<TipoReceita> lg = List.generate(todasLinhas.length, (i) {
      return TipoReceita(
          todasLinhas[i]['id'],
          todasLinhas[i]['nome'],
          todasLinhas[i]['descricao']
      );
    });
    return lg;
  }

  Future<TipoReceita> get(int id) async {
    String sql = ""
        "SELECT * "
        "FROM tipogasto"
        "WHERE id = $id;";
    final todasLinhas = await BdCore.instance.querySQL(sql);
    List<TipoReceita> lg = List.generate(todasLinhas.length, (i) {
      return TipoReceita(
        todasLinhas[i]['id'],
        todasLinhas[i]['nome'],
        todasLinhas[i]['descricao'],
      );
    });
    late TipoReceita c;
    try {
      c = lg.elementAt(0);
    }catch(_){}
    return c;
  }
}
