import 'package:flutter/material.dart';

class Mensagem {
  static void mostrarBarraMensagem(
      BuildContext context, Color cor, String mensagem) {
    SnackBar barraMensagem = SnackBar(
      backgroundColor: cor,
      content: Text(mensagem),
    );
    ScaffoldMessenger.of(context).showSnackBar(barraMensagem);
  }

  static Future<void> informar(BuildContext contexto, String mensagem) {
    return showDialog<bool>(
      context: contexto,
      barrierDismissible: true,
      builder: (BuildContext contexto) {
        return AlertDialog(
          title: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(contexto, false);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> confirmar(BuildContext context, String mensagem) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
