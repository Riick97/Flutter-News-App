import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../Widgets/BookmarksList.dart';

class BookMarksPage extends StatefulWidget {
  User? user;
  bool? cardView;

  BookMarksPage({Key? key, this.user, this.cardView}) : super(key: key);

  @override
  _BookMarksPageState createState() => _BookMarksPageState();
}

class _BookMarksPageState extends State<BookMarksPage> {
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
  }

  Column buildButtonColumn(IconData icon) {
    Color color = Theme.of(context).primaryColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Icon(icon, color: color),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Bookmarks'),
        ),
        body: BookmarksList(user: widget.user, cardView: widget.cardView));
  }
}
