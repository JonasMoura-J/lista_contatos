import 'package:flutter/material.dart';
import 'package:lista_contatos/controle_contato.dart';
import 'package:lista_contatos/utilitario_interface.dart';
import 'package:lista_contatos/mensagem.dart';
import 'package:lista_contatos/contato.dart';
import 'package:lista_contatos/base.dart';
import 'package:lista_contatos/pagina_contato.dart';

class PaginaCadastroContatos extends StatefulWidget {
  const PaginaCadastroContatos({Key? key}) : super(key: key);
  @override
  State<PaginaCadastroContatos> createState() => _PaginaCadastroContatosState();
}

class _PaginaCadastroContatosState extends State<PaginaCadastroContatos> {
  final ControleContato _controleContato = ControleContato();

  Future<bool> _executarOperacaoCadastro(BuildContext contexto,
      OperacaoCadastro operacaoCadastro, Contato contato) async {
    Contato? contatoRetornado =
        await Navigator.push(contexto, MaterialPageRoute(builder: (context) {
      return PaginaContato(operacaoCadastro, contato);
    }));
//Não usou os botões confirmar e cancelar
    if (contatoRetornado != null) {
      int resultado;
      if (operacaoCadastro == OperacaoCadastro.inclusao) {
        print('Iclusao: ' + contatoRetornado.nome);
        resultado = await _controleContato.incluir(contatoRetornado);
      } else {
        resultado = await _controleContato.alterar(contatoRetornado);
      }
      if (resultado > 0) {
        setState(() {
          Mensagem.mostrarBarraMensagem(
              contexto,
              Colors.black,
              operacaoCadastro == OperacaoCadastro.inclusao
                  ? 'Inclusão realizada com sucesso.'
                  : 'Alteração realizada com sucesso.');
        });
      } else {
        Mensagem.mostrarBarraMensagem(
            contexto, Colors.red, 'Operação não foi realizada.');
      }
    }
    return contatoRetornado != null;
  }

  Widget criarItem(BuildContext context, Contato contato) {
    return Dismissible(
      key: Key(contato.identificador.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        title: Text(
          contato.nome,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Contato ' + nomesTiposContatos[contato.tipoContato.index],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  contato.telefone,
                ),
              ],
            )
          ],
        ),
        trailing: UtilitarioInterface.criarBotaoIcone(
            icone: Icons.edit,
            funcaoToque: () {
              _executarOperacaoCadastro(
                  context, OperacaoCadastro.edicao, contato);
            }),
        onTap: () {},
        onLongPress: () async {
          _executarOperacaoCadastro(context, OperacaoCadastro.edicao, contato);
        },
      ),
      confirmDismiss: (DismissDirection direcao) async {
        return await Mensagem.confirmar(context, 'Confirma a exclusao?');
      },
      onDismissed: (direction) {
        setState(() async {
          await _controleContato.excluir(contato.identificador);
        });
      },
    );
  }

  Widget _criarVisualizadorLista(BuildContext context, List<Contato> contatos) {
//Separa os itens com uma linha separadora
    return ListView.separated(
      itemCount: contatos.length,
      itemBuilder: (context, index) {
        return criarItem(context, contatos[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
        );
      },
    );
  }

  FutureBuilder _criarListaContatos() {
    return FutureBuilder(
      initialData: [],
      future: _controleContato.obterListaContatos(),
      builder: (BuildContext contexto, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<Contato> && snapshot.data.isNotEmpty) {
            return _criarVisualizadorLista(contexto, snapshot.data);
          } else {
            return Center(
              child: Text('Não há contatos cadastrados.'),
            );
          }
        }
        return Center(child: Text('Não há contatos cadastrados.'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//key: _chaveScaffold,
      appBar: AppBar(
        title: Text(
          'Lista de Contatos',
        ),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: _criarListaContatos(),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(padding: EdgeInsets.all(24.0)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _executarOperacaoCadastro(
              context, OperacaoCadastro.inclusao, Contato());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
