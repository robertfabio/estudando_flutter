import 'dart:math';

import 'package:flutter/material.dart';

class GamePo extends StatefulWidget {
  const GamePo({super.key});

  @override
  State<GamePo> createState() => _GamePoState();
}

class _GamePoState extends State<GamePo> {
  final Map<String, int> escolhasMapa = {
    'pedra': 0,
    'papel': 1,
    'tesoura': 2,
  };

  final List<AssetImage> imagensOpcoes = [
    AssetImage('assets/jokenpo/pedra.png'),
    AssetImage('assets/jokenpo/papel.png'),
    AssetImage('assets/jokenpo/tesoura.png'),
  ];

  var _imagemApp = AssetImage('assets/jokenpo/padrao.png');
  var _mensagem = "Escolha uma opção abaixo";

  void opcaoSelecionada(String escolhaUsuario) {
    var escolhaUsuarioInt = escolhasMapa[escolhaUsuario]; // Converte a escolha do usuário para int
    if (escolhaUsuarioInt == null) return; // Segurança caso a string seja inválida

    var escolhaAppInt = Random().nextInt(3);

    setState(() {
      _imagemApp = imagensOpcoes[escolhaAppInt];
      if ((escolhaUsuarioInt == 0 && escolhaAppInt == 2) ||
          (escolhaUsuarioInt == 1 && escolhaAppInt == 0) ||
          (escolhaUsuarioInt == 2 && escolhaAppInt == 1)) {
        _mensagem = "Você ganhou! 🎉";
      }
      else if ((escolhaAppInt == 0 && escolhaUsuarioInt == 2) ||
          (escolhaAppInt == 1 && escolhaUsuarioInt == 0) ||
          (escolhaAppInt == 2 && escolhaUsuarioInt == 1)) {
        _mensagem = "Você perdeu! 😢";
      }
      else {
        _mensagem = "Empate! 🤝";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "JokenPo",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Text(
                "Escolha do App:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Image(image: this._imagemApp, width: 150, height: 150),
              Text(
                _mensagem,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Image(image: imagensOpcoes[0], height: 100),
                onTap: () {
                  opcaoSelecionada('pedra');
                },
              ),
              GestureDetector(
                child: Image(image: imagensOpcoes[1], height: 100),
                onTap: () {
                  opcaoSelecionada('papel');
                },
              ),
              GestureDetector(
                child: Image(image: imagensOpcoes[2], height: 100),
                onTap: () {
                  opcaoSelecionada('tesoura');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
