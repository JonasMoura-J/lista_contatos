import 'package:flutter/material.dart';
import 'base.dart';
import 'mensagem.dart';
import 'utilitario_interface.dart';

class PaginaEmail extends StatefulWidget {
  @override
  State<PaginaEmail> createState() => _PaginaEmailState();

  final String _email;
  final OperacaoCadastro _operacao;

  PaginaEmail(this._operacao, this._email);
}

class _PaginaEmailState extends State<PaginaEmail> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        key: Key('pagina_email'),
        child: Container(
          height: 220,
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: _criarFormulario(context),
        ),
      ),
    );
  }

  TextEditingController _controladorEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget._operacao == OperacaoCadastro.edicao) {
      _controladorEmail.text = widget._email;
    }
  }

  @override
  void dispose() {
    _controladorEmail.dispose();
    super.dispose();
  }

  bool _dadoInformado() {
    if (_controladorEmail.text == '') {
      Mensagem.informar(context, 'É necessário informar o email.');
      return false;
    }
    return true;
  }

  Widget _criarCaixaEdicaoEmail() {
    return TextField(
      controller: _controladorEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
      ),
    );
  }

  Widget _criarFormulario(BuildContext contexto) {
    return SingleChildScrollView(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                UtilitarioInterface.obterTituloOperacao(
                    widget._operacao, 'Email'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _criarCaixaEdicaoEmail(),
              SizedBox(height: 20),
              UtilitarioInterface.criarBotoesSalvarCancelar(funcaoSalvar: () {
                if (_dadoInformado()) {
                  Navigator.pop(contexto, _controladorEmail.text);
                }
              }, funcaoCancelar: () {
                Navigator.pop(contexto, '');
              }), //Fim de criarBotoesSalvarCancelar
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
