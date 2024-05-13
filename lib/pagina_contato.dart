import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lista_contatos/base.dart';
import 'package:lista_contatos/contato.dart';
import 'package:lista_contatos/mensagem.dart';
import 'package:lista_contatos/pagina_email.dart';
import 'package:lista_contatos/utilitario_interface.dart';

class PaginaContato extends StatefulWidget {
  final OperacaoCadastro _operacao;
  final Contato _contato;

  PaginaContato(this._operacao, this._contato);
  @override
  State<PaginaContato> createState() => _PaginaContatoState();
}

class _PaginaContatoState extends State<PaginaContato> {
  final _controladorNome = TextEditingController();
  final _controladorTelefone = TextEditingController();

  FocusNode _focoNome = FocusNode();
  FocusNode _focoTipoContato = FocusNode();

  List<DropdownMenuItem> _itensTipoContato = [];
  TipoContato _tipoContato = TipoContato.pessoal;
  DateTime? _dataNascimento;
  String _nomeArquivoFoto = '';
  List<String> _emails = [];

  void _carregarTiposContatos() {
    for (int i = 0; i < nomesTiposContatos.length; i++) {
      _itensTipoContato.add(DropdownMenuItem<TipoContato>(
        value: TipoContato.values[i],
        child: Text(nomesTiposContatos[i]),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarTiposContatos();
    if (widget._operacao == OperacaoCadastro.edicao) {
      _controladorNome.text = widget._contato.nome;
      _controladorTelefone.text = widget._contato.telefone;
      _tipoContato = widget._contato.tipoContato;
      _emails = widget._contato.emails.toList();
      if (widget._contato.dataNascimento != null) {
        _dataNascimento = widget._contato.dataNascimento;
      }
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorTelefone.dispose();
    super.dispose();
  }

  bool _dadosInformados(BuildContext contexto) {
    if (_controladorNome.text == '') {
      Mensagem.informar(context, 'É necessário informar o nome.');
      FocusScope.of(context).requestFocus(_focoNome);
      return false;
    }
    return true;
  }

  void _transferirDadosParaEntidade(Contato contato) {
    contato.nome = _controladorNome.text;
    contato.telefone = _controladorTelefone.text;
    contato.dataNascimento = _dataNascimento;
    contato.tipoContato = _tipoContato;
    contato.emails = _emails.toList();
  }

  Future<DateTime?> _selecionarData() async {
    DateTime dataInicial =
        _dataNascimento != null ? _dataNascimento! : DateTime.now();
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime.now().subtract(Duration(days: 36500)),
      lastDate: DateTime.now(),
    );
    return dataSelecionada;
  }

  Future<void> _executarOperacaoEmail(BuildContext contexto,
      OperacaoCadastro operacaoCadastro, int indice) async {
    String email = '';
    if (operacaoCadastro == OperacaoCadastro.edicao) {
      email = _emails[indice];
    }
    email =
        await Navigator.push(contexto, MaterialPageRoute(builder: (context) {
      return PaginaEmail(operacaoCadastro, email);
    }));
    if (email != '') {
      setState(() {
        if (operacaoCadastro == OperacaoCadastro.inclusao) {
          _emails.add(email);
        } else {
          _emails[indice] = email;
        }
      });
    }
  }

  Widget _criarItemEmail(BuildContext contexto, int indice) {
    return Dismissible(
      key: Key(_emails[indice]),
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
      child: Material(
        color: Colors.white, // button color
        child: InkWell(
          splashColor: Colors.black26, // inkwell color
          child: Container(
            padding: EdgeInsets.only(left: 5.0, top: 10),
            width: MediaQuery.of(context).size.width - 80,
            height: 40,
            child: Text(
              _emails[indice],
              style: TextStyle(fontSize: 16),
            ),
          ),
          onTap: () {
            _executarOperacaoEmail(context, OperacaoCadastro.edicao, indice);
          },
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _emails.removeAt(indice);
        });
      },
    );
  }

  Widget _criarListaEmails() {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 80,
      child: ListView.builder(
        itemCount: _emails.length,
        itemBuilder: (context, index) {
          return _criarItemEmail(context, index);
        },
      ),
    );
  }

  Widget _criarPainelEmais() {
    return Container(
      color: Colors.grey[200],
      height: 130,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Text(
            'Emails',
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              UtilitarioInterface.criarBotaoIcone(
                  icone: Icons.add,
                  corBotao: Colors.lightGreenAccent,
                  funcaoToque: () {
                    _executarOperacaoEmail(
                        context, OperacaoCadastro.inclusao, 0);
                  }),
              SizedBox(width: 10),
              _criarListaEmails(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _criarCaixaSelecaoData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Data de Nascimento',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
          textAlign: TextAlign.left,
        ),
        ElevatedButton(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                size: 22.0,
                color: Colors.black54,
              ),
              SizedBox(
                width: 16.0,
              ),
              Text(
                _dataNascimento != null
                    ? DateFormat('dd/MM/yyyy').format(_dataNascimento!)
                    : '-',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black54,
              ),
            ],
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            DateTime? dataSelecionada = await _selecionarData();
            setState(() {
              _dataNascimento = dataSelecionada;
            });
          },
        ),
      ],
    );
  }

  Widget _criarCaixaSelecaoTipoContato() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tipo',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
          textAlign: TextAlign.left,
        ),
        DropdownButton(
//itemHeight: 16,
          isExpanded: true,
          hint: Text('Tipo'),
          items: _itensTipoContato,
          value: _tipoContato, //Tem que ser o mesmo do SetState
          focusNode: _focoTipoContato,
          onChanged: (tipo) {
//É necessário ter o onChanged. Senão não funciona.
            setState(() {
              _tipoContato = tipo;
            });
          },
        ),
      ],
    );
  }

  Widget _criarCaixaEdicaoTelefone() {
    return TextField(
      controller: _controladorTelefone,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9,(,), -]'))
      ],
      decoration: InputDecoration(
        labelText: 'Telefone',
      ),
    );
  }

  Widget _criarConteudoFormulario(BuildContext contexto) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 5),
//Principais dados do contato------------------
            Container(
              width: MediaQuery.of(context).size.width - 70,
              height: 265,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//Nome -----------------------------------
                  TextField(
                    controller: _controladorNome,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                    focusNode: _focoNome,
                  ),
                  SizedBox(height: 10),
                  _criarCaixaSelecaoTipoContato(),
                  _criarCaixaSelecaoData(),
                  _criarCaixaEdicaoTelefone(),
                ],
              ),
            ),
          ],
        ),
        _criarPainelEmais(),
      ],
    );
  }

  Widget _criarFormulario(BuildContext contexto) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          _criarConteudoFormulario(contexto),
          SizedBox(
            height: 10.0,
          ),
          UtilitarioInterface.criarBotoesSalvarCancelar(funcaoSalvar: () {
            if (_dadosInformados(contexto)) {
              Contato contato;
              if (widget._operacao == OperacaoCadastro.inclusao) {
                contato = Contato();
              } else {
                contato = widget._contato;
              }
              _transferirDadosParaEntidade(contato);
              Navigator.pop(contexto, contato);
            }
          }, funcaoCancelar: () {
            Navigator.pop(contexto, null);
          }),
        ],
      ),
    );
  }

  Widget build(BuildContext contexto) {
    return Scaffold(
      key: Key('pagina_contato'),
      appBar: AppBar(
        title: Text(
          UtilitarioInterface.obterTituloOperacao(widget._operacao, 'Contato'),
        ),
        centerTitle: true,
      ),
      body: _criarFormulario(contexto),
    );
  }
}
