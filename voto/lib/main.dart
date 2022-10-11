//EXEMPLOS PARA MANIPULAÇÃO FIRESTORE
//https://github.com/firebase/snippets-flutter/blob/6bfe43fd8750a81189fd975b9910beaafd7dc697/packages/firebase_snippets_app/lib/snippets/firestore.dart#L90-L90


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//mandaram adicionar
import 'package:firebase_core/firebase_core.dart';
import 'package:voto/model/Voto.dart';
import 'firebase_options.dart';

void main() async {
  //necessário inicialiar todos os widgets
  WidgetsFlutterBinding.ensureInitialized();

  //necessário para inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());

}
final String nomeColecao = "votacao";
/*
late FirebaseFirestore db = FirebaseFirestore.instance
    .collection(nomeColecao) //pegando a referência da coleção de candidato firestore-exemplo
    //Assim podemos persistir o objeto no firebase direto como json
    .withConverter<Voto>(
  fromFirestore: (snapshots, _) => Voto.fromJson(snapshots.data()!),
  toFirestore: (objeto, _) => objeto.toJson(),
) as FirebaseFirestore;
*/
late FirebaseFirestore db = FirebaseFirestore.instance;


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  late List docs_paths = [];
  final Stream<QuerySnapshot>? _votosStream = FirebaseFirestore.instance.collection(nomeColecao).snapshots();


  @override
  void initState() {
    super.initState();
    _criaCandidatosNoFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Valor no servindor:',
              ),

              Expanded(child: //stream de exibição de dados
              StreamBuilder<QuerySnapshot>(
                stream: _votosStream!,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  //se o snap ainda não tem dados, printa o circualr indicator
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.requireData;

                  //monta o retorno do listview
                  return ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['candidato']),
                        subtitle: Text(data['votos'].toString()),
                      );
                    }).toList().cast(),
                  );
                },
              ),),
              // este exemplo usa 'snapshots in sync', sincronização automática de dados.
              StreamBuilder(
                stream: FirebaseFirestore.instance.snapshotsInSync(),
                builder: (context, _) {
                  return Text(
                    'Ultima atualização: ${DateTime.now()}',
                    style: Theme.of(context).textTheme.caption,
                  );
                },
              ),
              Text(
                '',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),

        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 10,),
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () async{
                //int indiceCandidato = 1;
                print('foi');
                Voto v = await getObjeto(nomeColecao, '13') ;
                print('voto:'+v.toString());
                _votaCandidato(v);
              },
              tooltip: 'Votar Lula',
              child: const Icon(Icons.plus_one_outlined, ),
            ),
            Container(height: 10,),
            FloatingActionButton(
              backgroundColor: Colors.black87,
              onPressed: () async{
                //int indiceCandidato = 1;
                print('foi');
                Voto v = await getObjeto(nomeColecao, '22') ;
                print('voto:'+v.toString());
                _votaCandidato(v);
              },
              tooltip: 'Votar Bolsonaro',
              child: const Icon(Icons.plus_one_outlined),
            ),
            Container(height: 10,),
            FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: _resetVotos,
              tooltip: 'Zear Votos',
              child: const Icon(Icons.delete),
            ),

          ],
        )
    );
  }

  /////////////////////////////////////////////////////////////////////////
  //a partir daqui os métodos já fazem parte do modelo de negócio do app
  /////////////////////////////////////////////////////////////////////////

  /**
   * método responsável por criar os candidatos no firebase
   */

  Future<void> _criaCandidatosNoFirebase() async {
    if (await getQtdDocs(nomeColecao)!=0) {
      return;
    }
    //inicializa votos
    Voto candidato = Voto(id:13, candidato: "Lula", votos: 0);
    setDoc(nomeColecao, candidato);
    candidato = Voto(id: 22, candidato: "Bolsonaro",votos: 0);
    setDoc(nomeColecao, candidato);
  }

  /**
   * método responsável por incrementar votos ao candidato no firebase
   */
  Future<void> _votaCandidato(Voto objVoto) async {
    objVoto.votos = (objVoto.votos! + 1)!;
    setDoc(nomeColecao, objVoto);

  }

  /**
   * método responsável por resetar os votos de todos os candidatos no firebase
   */
  Future<void> _resetVotos() async {
    //pegando a referência da coleção de candidato firestore-exemplo
    final referenciaColecao = FirebaseFirestore.instance.collection(nomeColecao);
    final colecao = await referenciaColecao.get();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    //roda todos os documentos da coleção zerando o valor de uma chave
    for (final objeto in colecao.docs) {
      batch.update(objeto.reference, {'votos': 0});
    }
    await batch.commit();
  }



  /////////////////////////////////////////////////////////
  /// MÉTODOS BASE PARA MANIPULAÇÃO FIREBASE

  /**
   * método que atualiza ou adiciona um documento a uma coleção
   */
  void setDoc(String colecao, Voto votoObj){
    db
        .collection(colecao)
        .doc(votoObj.id.toString())
        .set(votoObj.toJson())
        .onError((e, _) => print("Erro ao definir o doc: $e"));
  }

  /**
   * Método responsável por adicionar um doc em uma coleção,
   * criando um indice aleatóreo
   */
  void addDocs(String colecao, Voto votoObj){
    // Adiciona novo documento à coleção votos gerando um ID para o mesmo
    db.collection(colecao).add(votoObj.toJson()).then((DocumentReference doc) =>(){

    });
  }

  /**
   * método responsável por resgatar documento do firebase
   */
  Future<Voto> getObjeto(String colecao, String pathDoc) async {
    final ref = db.collection(colecao).doc(pathDoc).withConverter<Voto>(
      fromFirestore: (snapshots, _) => Voto.fromJson(snapshots.data()!),
      toFirestore: (Voto voto, _) => voto.toJson(),
    );
    final docSnap = await ref.get();
    final voto = docSnap.data(); //Converte os dados para o objeto voto
    if (voto != null) {
      print(voto);
    } else {
      print("Documento não encontrado.");
    }
    return voto!;
  }

  /**
   * metodo responsável por deletar documentos no firebase
   */
  Future deleteDoc(String colecao,String pathDoc) async {
    // [START delete_data_delete_docs]
    await db.collection(colecao).doc(pathDoc).delete().then(
          (doc) => print("Documento deletado"),
      onError: (e) => print("ERRO AO DELETAR $e"),
    );
  }

  /**
   * método responsável por resgatar múltiplos documentos do firebase, documentos de uma coleção
   */
  Future<List<Voto>> getAllDocsFromCollection(String colecao) async{
    late List<Voto> respx = [];
    final  ref = await db.collection(colecao).where(nomeColecao).get();
    ref.docs.forEach((element) {
      respx.add(Voto.fromJson(element.data()));
    });
    return respx;
  }

  /**
   * método que pega uma lista de indices dos documentos de uma coleção
   */
  Future<List<String>> getIndicesDocs(String colecao) async{
    late List<String> respx = [];
    final  ref = await db.collection(colecao).where(nomeColecao).get();
    ref.docs.forEach((element) {
      respx.add(element.id);
    });
    return respx;
  }

  /**
   *método responsável por atualizar documentos no firebase
   */
  void updateDocs(String colecao, String pathDoc, Voto objVoto){
    db.collection(colecao).doc(pathDoc).update(objVoto.toJson());
  }

  /**
   * método realiza um tipo de atualização, se não houver o elemento
   * ou a coleção os mesmos são criados
   */
  void updateDocs2(String colecao, Voto objVoto){
    db.collection(colecao).doc().set(objVoto.toJson());
  }

  /**
   * método que pega a quantidade de documentos existe em uma coleção
   */
  Future<int> getQtdDocs(String colecao) async {
    final x = await db.collection(colecao).get();
    return x.size;
  }



///////////////////////////////////////////////////////
/*
   late int _likes;
  Future<void> _onLike() async {
    final currentLikes = _likes;

    // Increment the 'like' count straight away to show feedback to the user.
    setState(() {
      _likes = currentLikes + 1;
    });

    //FirebaseFirestore.instance.collection('collectionPath').add('data');


    try {

      int newLikes = await FirebaseFirestore.instance
          .runTransaction<int>((transaction) async {

              DocumentSnapshot<Voto> objeto =
            await transaction.get<Voto>(DocumentRefere);

            if (!objeto.exists) {
              throw Exception('Documento não existe!');
            }

            //incrementa votos de um referido candidato
            int updatedLikes = objeto.data()!.votos + 1;
            transaction.update(widget.reference, {'likes': updatedLikes});
            return updatedLikes;
      });
      // Update with the real count once the transaction has completed.
      setState(() => _likes = newLikes);
    } catch (e, s) {
      print(s);
      print('Failed to update likes for document! $e');

      // If the transaction fails, revert back to the old count
      setState(() => _likes = currentLikes);
    }
  }
*/
}