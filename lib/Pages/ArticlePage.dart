import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ArticlePage extends StatefulWidget {
  final String? postUrl;
  ArticlePage({@required this.postUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticlePage> {
  User? user;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _auth.userChanges().listen((event) => setState(() => user = event));
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.postUrl!,
      appBar: new AppBar(
        title: new Text("News"),
      ),
    );
  }
}
