import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dicionario_dados.dart';

class Arquivo{
  String _nomeArquivo = '';

  Arquivo();

  factory Arquivo.instancia() => Arquivo();

  Future<String> _obterNomeArquivo() async {
    if (_nomeArquivo.isEmpty){
      Directory diretorio = await getApplicationDocumentsDirectory();
      _nomeArquivo = diretorio.path +'/'+DicionarioDados.nomeArquivo;
    }
    return  _nomeArquivo;
  }

  Future<File> _obterArquivo() async {
    String nomeArquivo = await _obterNomeArquivo();
    return File(nomeArquivo);
  }

  Future<String> lerArquivo() async{
    File arquivo = await _obterArquivo();
    String conteudo;
    if (arquivo.existsSync()){
      conteudo = await arquivo.readAsString();
    } else {
      conteudo = '{"$DicionarioDados.contatos":[]}';
    }
    return conteudo;
  } 

  Future<void> salvarArquivo(String conteudo) async{
    File arquivo = await _obterArquivo();
    await arquivo.writeAsString(conteudo);

  }
}