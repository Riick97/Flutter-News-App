import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_news/Models/NewsApiResponseModel.dart';
import 'LoadingFooter.dart';
import './NewsCard.dart';
import './NewsCardTile.dart';
import '../Models/ArticleModel.dart';
import '../Data/NewsApi.dart';
import '../Controllers/ThemeBloc.dart';

class NewsList extends StatefulWidget {
  final String? category;
  final String? sort;
  final User? user;
  bool? cardView;

  NewsList({Key? key, this.category, this.sort, this.user, this.cardView})
      : super(key: key);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  int _pageCount = 0;
  double _scrollOffset = 0.0;
  ScrollController? _controller;

  static const int IDLE = 0;
  static const int LOADING = 1;
  static const int ERROR = 3;
  static const int EMPTY = 4;

  int _status = LOADING;
  int _footerStatus = LoadingFooter.IDLE;

  List<Article>? _articles;
  Completer<Null>? _completer;

  final sortBloc = SortBloc();
  String? sort;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller!.addListener(() {
      if (_footerStatus == LoadingFooter.IDLE &&
          _controller!.offset > _scrollOffset &&
          _controller!.position.maxScrollExtent - _controller!.offset < 100) {
        loadMore();
      }
      _scrollOffset = _controller!.offset;
    });
    sort = widget.sort!;
    final sub = sortBloc.sortStream.listen((event) {
      setState(() {
        sort = event;
      });
      _getNews();
    });
    _getNews();
  }

  Future _getNews() async {
    _pageCount = 0;
    NewsApiResonse? news = await NewsApi.fetchNews(
        offset: _pageCount, category: widget.category!, sort: sort!);
    _articles = news!.articles;

    setState(() {
      if ("OK".compareTo(news.status!) != 0) {
        _status = ERROR;
      } else if (_articles?.isEmpty ?? false) {
        _status = EMPTY;
      } else {
        _pageCount++;
        _status = IDLE;
      }
    });
  }

  Future loadMore() async {
    setState(() {
      _footerStatus = LoadingFooter.LOADING;
    });
    NewsApiResonse? news = await NewsApi.fetchNews(
        offset: _pageCount * 25,
        category: widget.category!,
        sort: widget.sort!);
    setState(() {
      if (news?.articles?.isNotEmpty ?? false) {
        _pageCount++;
      }
      _articles!.addAll(news!.articles!);
      _footerStatus = LoadingFooter.IDLE;
    });
  }

  Future<Null> _onRefresh() {
    _completer = new Completer<Null>();
    _getNews();
    return _completer!.future;
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case IDLE:
        return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
                padding: EdgeInsets.only(top: 18),
                itemCount: _articles!.length + 1,
                itemBuilder: (context, index) {
                  if (index == _articles!.length) {
                    return LoadingFooter(
                        retry: () {
                          loadMore();
                        },
                        state: _footerStatus);
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
