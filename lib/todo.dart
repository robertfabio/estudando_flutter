import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LISTA()));
}

class LISTA extends StatefulWidget {
  const LISTA({super.key});

  @override
  State<LISTA> createState() => _LISTAState();
}

class _LISTAState extends State<LISTA> {
  final _toDoController = TextEditingController();
  List _toDoList = [];
  late Map<String, dynamic> _lastRemoved;
  late int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      if (data.isNotEmpty) {
        try {
          setState(() {
            _toDoList = json.decode(data);
          });
        } catch (e) {
          print("Erro ao decodificar dados: $e");
          // Opcional: resetar _toDoList ou mostrar erro ao usuário
          setState(() {
            _toDoList = [];
          });
        }
      }
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/LISTA.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        return file.readAsString();
      }
      return "";
    } catch (e) {
      print("Erro ao ler arquivo: $e");
      return "";
    }
  }

  void _addToDo() {
    if (_toDoController.text.isNotEmpty) {
      setState(() {
        Map<String, dynamic> newToDo = Map();
        newToDo["title"] = _toDoController.text;
        _toDoController.text = "";
        newToDo["ok"] = false;
        _toDoList.add(newToDo);
        _saveData();
      });
    }
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString() + index.toString()),
      // Unique key
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          // PRIMEIRO, guardamos o item que será removido e sua posição
          _lastRemoved = Map<String, dynamic>.from(_toDoList[index]);
          _lastRemovedPos = index;

          // DEPOIS, removemos o item da lista
          _toDoList.removeAt(index);
          _saveData();

          // AGORA, _lastRemoved e _lastRemovedPos têm os valores corretos
          // para o item que acabamos de remover.
          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _toDoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );

          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 10.0, 7.0, 10.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.0,
                    child: CupertinoTextField(
                      controller: _toDoController,
                      placeholder: "Adicionar Nova Tarefa",
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightBlue.shade200,
                        ),
                        // boxShadow: [], // pode ser removido se vazio
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      placeholderStyle: TextStyle(
                        color: Colors.lightBlue.shade200,
                        fontSize: 18.0,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      cursorColor: Colors.lightBlue.shade200,
                      onSubmitted: (_) => _addToDo(),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                CupertinoButton(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  pressedOpacity: 0.8,
                  onPressed: _addToDo,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshList,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: buildItem,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshList() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _readData();

      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"]) return 1;
        if (!a["ok"] && b["ok"]) return -1;
        return 0;
      });

      _saveData();
    });
    return null;
  }
}