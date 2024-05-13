import 'base.dart';
import 'dicionario_dados.dart';

class Contato{
  int identificador = 0;
  String nome = '';
  String telefone = '';
  DateTime? dataNascimento;
  TipoContato tipoContato = TipoContato.pessoal;
  List<String> emails = [];

  Contato();

  Contato.criarDeMapa(Map<String, dynamic> mapa){
    identificador = mapa[DicionarioDados.idContato];
    nome = mapa[DicionarioDados.nome];
    telefone = mapa[DicionarioDados.telefone];
    dataNascimento = mapa[DicionarioDados.dataNascimento] != null
                     ? DateTime.parse(mapa[DicionarioDados.dataNascimento])
                     : null;
    
    tipoContato = TipoContato.values[mapa[DicionarioDados.tipoContato]];                 
    
    emails = mapa[DicionarioDados.emails].length > 0
             ? mapa[DicionarioDados.emails].toList()
             : <String>[];


  }

  Map<String, dynamic> gerarMapa(){
    var mapa = <String,dynamic>{
      DicionarioDados.idContato : identificador,
      DicionarioDados.nome : nome,
      DicionarioDados.dataNascimento : dataNascimento != null
         ? dataNascimento.toString()
         : null,
      DicionarioDados.tipoContato	: tipoContato.index,
      DicionarioDados.telefone : telefone,
      DicionarioDados.emails : emails,
    };
    return mapa;
  }   
  
}