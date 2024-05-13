import 'dart:convert';
import 'arquivo.dart';
import 'dicionario_dados.dart';
import 'contato.dart';

class ControleContato {
  int _idContato = 0;
  Map<int, Contato> _contatos = <int, Contato>{};

  Future<void> lerContatos() async {
    String conteudo = await Arquivo.instancia().lerArquivo();
    Map<String, dynamic> mapaCompleto = json.decode(conteudo);
    _idContato = 0;
    mapaCompleto[DicionarioDados.contatos].forEach((mapa) {
      Contato contato = Contato.criarDeMapa(mapa);
      _contatos[contato.identificador] = contato;
      if (contato.identificador >= _idContato) {
        _idContato = contato.identificador + 1;
      }
    });
  }

  Future<List<Contato>> obterListaContatos() async {
    if (_contatos.isEmpty) {
      await lerContatos();
    }
    List<Contato> listaContatos = _contatos.values.toList();
    listaContatos
        .sort((contato1, contato2) => contato1.nome.compareTo(contato2.nome));
    return listaContatos;
  }

  Map<String, dynamic> _gerarMapa() {
    List<Map<String, dynamic>> mapasContatos = <Map<String, dynamic>>[];
    _contatos.values.forEach((contato) {
      mapasContatos.add(contato.gerarMapa());
    });
    return <String, dynamic>{
      DicionarioDados.contatos: mapasContatos,
    };
  }

  Future<void> _salvar() async {
    Map<String, dynamic> mapa = _gerarMapa();
    String conteudo = json.encode(mapa);
    await Arquivo.instancia().salvarArquivo(conteudo);
  }

  Future<int> incluir(Contato contato) async {
    try {
      _idContato++;
      contato.identificador = _idContato;
      _contatos[_idContato] = contato;
      await _salvar();
      return contato.identificador;
    } catch (e) {
      return -1;
    }
  }

  Future<int> alterar(Contato contato) async {
    try {
      _contatos[contato.identificador] = contato;
      await _salvar();
      return contato.identificador;
    } catch (e) {
      return -1;
    }
  }

  Future<int> excluir(int idContato) async {
    try {
      _contatos.remove(idContato);
      await _salvar();
      return idContato;
    } catch (e) {
      return -1;
    }
  }
}
