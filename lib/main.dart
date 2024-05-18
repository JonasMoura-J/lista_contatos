import 'package:flutter/material.dart';
import 'package:lista_contatos/pagina_cadastro_contato.dart';

void main() {
  runApp(const AplicativoListaContatos());
}

class AplicativoListaContatos extends StatelessWidget {
  const AplicativoListaContatos({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Contatos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.white,
      ),
      //
      // supportedLocales: [const Locale('pt', 'BR')],
      home: PaginaCadastroContatos(),
    );
  }
}
