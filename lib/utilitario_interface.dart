import 'package:flutter/material.dart';
import 'base.dart';

class UtilitarioInterface {
  static String obterTituloOperacao(
      OperacaoCadastro operacaoCadastro, String titulo) {
    String tituloOperacao;
    switch (operacaoCadastro) {
      case OperacaoCadastro.inclusao:
        tituloOperacao = 'Inclusão de ';
        break;
      case OperacaoCadastro.edicao:
        tituloOperacao = 'Edição de ';
        break;
      case OperacaoCadastro.selecao:
        tituloOperacao = 'Seleção de ';
    }
    tituloOperacao = tituloOperacao + titulo;
    return tituloOperacao;
  }

  static Widget criarBotoesSalvarCancelar(
      {required Function funcaoSalvar, required Function funcaoCancelar}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
            child: SizedBox(
              width: 70,
              child: Center(
                child: const Text('Salvar'),
              ),
            ),
            onPressed: () {
              funcaoSalvar();
            }),
        SizedBox(
          width: 50.0,
        ),
        ElevatedButton(
          child: SizedBox(
            child: Center(
              child: const Text('Cancelar'),
            ),
          ),
          onPressed: () {
            funcaoCancelar();
          },
        )
      ],
    );
  }

  static Widget criarBotaoIcone(
      {required IconData icone,
      required Function funcaoToque,
      Color corIcone = Colors.black,
      Color corBotao = Colors.white}) {
    return ClipOval(
      child: Material(
        color: corBotao, // button color
        child: InkWell(
          splashColor: Colors.black26, // inkwell color
          child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                icone,
                color: corIcone,
                size: 30,
              )),
          onTap: () {
            funcaoToque();
          },
        ),
      ),
    );
  }
}
