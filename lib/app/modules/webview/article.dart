import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // Inisialisasi WebViewController dengan URL awal
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.besgerpet.com/News.html')); // Ganti dengan URL artikel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CatCare Articles'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _webViewController.reload(); // Untuk me-refresh halaman
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: _webViewController), // Menampilkan WebView dengan controller
    );
  }
}
