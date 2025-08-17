import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;
  const GifPage(this._gifData, {super.key});

  get item => null;

  @override
  Widget build(BuildContext context) {

    String imageUrl = "";
    String title = "GIF";

    try {
      imageUrl = _gifData['images']['fixed_height']['url'] as String? ?? "";

    } catch (e) {
      print("Erro ao acessar dados do GIF em GifPage: $e");

    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData['title'] ?? title),
        centerTitle: true,
        backgroundColor: Colors.black54,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('Teste nessa porra');
            },
            color: Colors.white,
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: imageUrl.isNotEmpty
              ? Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'Erro ao carregar GIF',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          )
              : Center( // Caso a URL não seja encontrada ou _gifData seja nulo
            child: Text(
              'Não foi possível carregar o GIF.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

