import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(home: IMCscren(), debugShowCheckedModeBanner: false));
}

class IMCscren extends StatefulWidget {
  const IMCscren({super.key});

  @override
  State<IMCscren> createState() => _IMCscrenState();
}

class _IMCscrenState extends State<IMCscren> {
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String resultText = 'Info';

  void _resetFields() {
    pesoController.text = '';
    alturaController.text = '';
    setState(() {
      resultText = '';
    });
  }

  void _calculate() {
    setState(() {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(alturaController.text) / 100;
      double imc = peso / (altura * altura);
      if (imc < 18.6) {
        resultText = 'Abaixo do peso (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 18.6 && imc < 24.9) {
        resultText = 'Peso ideal (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 24.9 && imc < 29.9) {
        resultText = 'Levemente acima do peso (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 29.9 && imc < 34.9) {
        resultText = 'Obesidade Grau I (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 34.9 && imc < 39.9) {
        resultText = 'Obesidade Grau II (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 40) {
        resultText = 'Obesidade Grau III (${imc.toStringAsPrecision(3)})';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora IMC', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: _resetFields,
            icon: Icon(Icons.refresh_sharp, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/back.jpg', fit: BoxFit.cover),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 120,
                    color: Colors.blueAccent[100],
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira seu Peso!';
                      }
                      return null;
                    },
                    controller: pesoController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Peso (kg)',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira sua altura!';
                      }
                      return null;
                    },
                    controller: alturaController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Altura (cm)',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _calculate();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Calcular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '$resultText',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )],
      ),
    );
  }
}
