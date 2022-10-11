import 'dart:convert';

class Voto {
  late int? id;
  late String? candidato;
  late int? votos;

  //método construtor
  Voto({this.id, this.candidato, this.votos});


  @override
  String toString() {
    return 'Pessoa{id: $id, candidato: $candidato, votos: $votos}';
  }

  factory Voto.build(String raw) {
    return Voto.fromJson(jsonDecode(raw));
  }

  ///Cria um JSON a partir da class
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['candidato'] = this.candidato;
    data['votos'] = this.votos;
    return data;
  }

  ///Retorna um novo objeto apartir de um json de entrada
  factory Voto.fromJson(Map<String, dynamic> json) {
    return Voto(id: int.parse(json['id'].toString()),candidato:  json['candidato'] as String,votos:  int.parse(json['votos'].toString()));
  }

  Voto.fromMap(Map<String, dynamic> mapa) {
    // pegarei o mapa que estamos recebendo da funcao acima e colocando em name
    this.id= mapa['id'];
    this.candidato = mapa['candidato'];
    this.votos = mapa['votos'];
  }


  /**
   * recebe um objeto dinâmico e preenche o objeto
   */
  Voto.map(dynamic obj) {
    // quando passamos um name ele já recebe como objeto
    this.id = obj['id'];
    this.candidato = obj['candidato'];
    this.votos= obj['votos'];

  }
  /**
   * converte o objeto atual para um mapa dinâmico
   */
  Map<String, dynamic>? toMap() {
    var mapa = new Map<String, dynamic>();
    mapa["id"] = id;
    mapa["candidato"] = candidato;
    mapa["votos"] = votos;
    return mapa;
  }

}