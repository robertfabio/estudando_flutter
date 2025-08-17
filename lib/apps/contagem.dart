import 'package:flutter/material.dart';

void main() {

  runApp(MaterialApp(
      title: 'Alt Counter',
      debugShowCheckedModeBanner: false,
      home: Contador()));

}

class Contador extends StatefulWidget {
  const Contador({super.key});

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {

  String _infoText = 'Quantas vezes você apertou o botão';

  int _contagem = 0;

  void _changeContagem(int delta) {
    setState(() {
      _contagem += delta;

      if(_contagem < 0) {
        _infoText = 'Contagem negativa? Não podi';
      } else if(_contagem <= 7) {
        _infoText = 'Aperte o botão';
      } else {
        _infoText = 'Apertou bem!';
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
            'assets/back1.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contagem: $_contagem',
              style: TextStyle(color: Colors.pinkAccent, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    _changeContagem(1);
                  },
                  child: Text(
                      '+1',
                      style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    _changeContagem(-1);
                  },
                  child: Text(
                      '-1',
                      style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.bold)),
                )],
            ),
            Text(
              _infoText,
              style: TextStyle(color: Colors.pinkAccent, fontSize: 20, fontStyle: FontStyle.italic),
            )],
        ),
      ],
    );
  }
}



