import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import 'gif_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _pesquisa;
  int _offset = 0;

  Future<Map> _getPesquisas() async {
    http.Response response;
    final query = _pesquisa?.trim() ?? "";

    response = await http.get(
      Uri.parse(
        "https://api.giphy.com/v1/gifs/search?api_key=aReYdvBJlxUiQJO1TYHPpVlNbzfgvrbQ&q=$query&limit=20&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips",
      ),
    );
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif',
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network( // Imagem de fundo
            'https://i.pinimg.com/1200x/fb/32/30/fb323017e1126d6dfaa59a6c874742c3.jpg',
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: Center(child: Text('Erro ao carregar imagem de fundo',
                    style: TextStyle(color: Colors.white70))),
              );
            },
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: CupertinoTextField(
                  placeholder: 'Pesquisar GIPHYs...',
                  placeholderStyle: TextStyle(color: Colors.white70),
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 0.8),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  prefix: Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Icon(CupertinoIcons.search, color: Colors.white70),
                  ),
                  onSubmitted: (text) {
                    setState(() {
                      _pesquisa = text.trim();
                      _offset = 0;
                    });
                  },
                  clearButtonMode: OverlayVisibilityMode.editing,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: FutureBuilder<Map>(
                  future: _getPesquisas(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        if (_pesquisa == null && _offset == 0) {
                          return Center(
                            child: Text(
                              "Digite algo para pesquisar GIFs!",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors
                                .white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(child: Text(
                              "Erro ao carregar GIFs.", style: TextStyle(
                              color: Colors.redAccent, fontSize: 16)));
                        } else if (snapshot.data == null ||
                            snapshot.data!["data"] == null ||
                            (snapshot.data!["data"] as List).isEmpty &&
                                (_pesquisa != null && _pesquisa!.isNotEmpty)) {
                          return Center(
                            child: Text(
                              "Nenhum GIF encontrado para $_pesquisa",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        else {
                          return _createGifTable(context, snapshot);
                        }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context,
      AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
    List gifs = snapshot.data!["data"] as List;
    int gifCount = gifs.length;

    bool showLoadMoreButton = (_pesquisa != null && _pesquisa!.isNotEmpty &&
        gifCount > 0 &&
        gifCount == 20);

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: gifCount + (showLoadMoreButton ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < gifCount) {
          final item = gifs[index];
          final imageUrl = item?["images"]?["fixed_width_small"]?["url"];

          if (imageUrl == null) {
            return Container(
              color: Colors.grey[850],
              child: Center(
                  child: Icon(Icons.broken_image, color: Colors.grey[600])),
            );
          }

          return GestureDetector(
            onTap: () {
              if (snapshot.data?["data"]?[index] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GifPage(snapshot.data!["data"][index]),
                  ),
                );
              }
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data?["data"]?[index]?["images"]?["fixed_width_small"]?["url"],
              height: 300,
              width: 300,
              fit: BoxFit.cover,
              imageErrorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container(
                  color: Colors.grey[850],
                  child: Center(
                    child: Icon(
                        Icons.error_outline, color: Colors.redAccent, size: 40),
                  ),
                );
              },
            ),
          );
        } else if (showLoadMoreButton && index == gifCount) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _offset += 20;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.add, color: Colors.white70, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Carregar mais...',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
