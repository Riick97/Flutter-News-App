import 'dart:async';
import 'package:flutter/material.dart';

import 'LoadingFooter.dart';
import './NewsCardTile.dart';
import './NewsCard.dart';
import '../Models/ArticleModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarksList extends StatefulWidget {
  User? user;
  bool? cardView;

  BookmarksList({Key? key, this.user, this.cardView}) : super(key: key);

  @override
  _BookmarksListState createState() => _BookmarksListState();
}

class _BookmarksListState extends State<BookmarksList> {
  ScrollController? _controller;
  Stream<List>? saved;

  static const int IDLE = 0;
  static const int LOADING = 1;
  static const int ERROR = 3;
  static const int EMPTY = 4;

  int _status = IDLE;
  int _footerStatus = LoadingFooter.IDLE;
  List<Article>? _articles = [];
  Completer<Null>? _completer;
  CollectionReference? bookMarksRef;

  @override
  void initState() {
    super.initState();
    _status = LOADING;
    _controller = ScrollController();
    String collectionName = widget.user != null ? widget.user!.uid : 'none';
    bookMarksRef = FirebaseFirestore.instance.collection(collectionName);
    _getBookmarks();
  }

  Future _getBookmarks() async {
    var snapshot = bookMarksRef!.get();
    var data = snapshot.then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _articles!.add(Article.fromSnapshot(doc));
        });
      });
    });

    setState(() {
      _status = IDLE;
    });
  }

  Future<Null> _onRefresh() {
    _completer = new Completer<Null>();
    _getBookmarks();
    return _completer!.future;
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case IDLE:
        return _articles!.length == 0
            ? Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Icon(Icons.chrome_reader_mode,
                        color: Colors.grey, size: 60.0),
                    new Text(
                      widget.user != null
                          ? "No articles saved"
                          : 'Login to see bookmarks',
                      style: new TextStyle(fontSize: 24.0, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 18),
                    itemCount: _articles!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _articles!.length) {
                        return LoadingFooter(
                            retry: () {}, state: _footerStatus);
                      } else if (_articles![index].urlToImage != null) {
                        return widget.cardView == true
                            ? NewsCard(
                                imgUrl: _articles![index].urlToImage ?? "",
                                title: _articles![index].title ?? "",
                                desc: _articles![index].description ?? "",
                                content: _articles![index].content ?? "",
                                posturl: _articles![index].url ?? "",
                                user: widget.user,
                              )
                            : NewsCardTile(
                                imgUrl: _articles![index].urlToImage ?? "",
                                title: _articles![index].title ?? "",
                                desc: _articles![index].description ?? "",
                                content: _articles![index].content ?? "",
                                posturl: _articles![index].url ?? "",
                                user: widget.user,
                              );
                      } else {
                        return Container();
                      }
                    },
                    controller: _controller));
      case LOADING:
        return Center(child: CircularProgressIndicator());
      case ERROR:
        return Center(
            child: Text(
                "Something is wrong, you might need to reboot your phone."));
      case EMPTY:
        return Center(child: Text("No news is good news!"));
      default:
        return Center(child: Text("Emm..."));
    }
  }
}
