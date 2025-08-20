import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HOMEFULL()));
}

class HOMEFULL extends StatefulWidget {
  const HOMEFULL({super.key});

  @override
  State<HOMEFULL> createState() => _HOMEFULLState();
}

class _HOMEFULLState extends State<HOMEFULL> {
  int _numeroAleatorio = 0;
  final List<String> _frases = [
    "Você é ruim",
    "Você precisa morrer",
    "Você é feio",
    "Você não sabe fazer nada",
    "Você é muito feio",
    "Inútil",
    "Burro",
    "Você é um lixo",
    "Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hass",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/rage.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            constraints: BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _frases[_numeroAleatorio],
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CupertinoButton(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  padding: EdgeInsets.all(10),
                  autofocus: true,
                  child: Text("Nova Frase", style: TextStyle(fontSize: 30, color: Colors.white)),
                  onPressed: () {
                    setState(() {});
                    _numeroAleatorio = Random().nextInt(_frases.length);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
