import 'dart:async';
import 'package:flutter_news/Models/NewsApiResponseModel.dart';
import '../Data/NewsApi.dart';

class ArticleCollectionBloc {

  final StreamController<NewsApiResonse> _articles = StreamController();
  Stream<NewsApiResonse> get articles => _articles.stream;


  searchArticles(String keywords) async {
    NewsApiResonse? articleCollection =
        await NewsApi.fetchNews(keywords: keywords);
    _articles.sink.add(articleCollection!);
  }

  dispose() {
    _articles.close();
  }
}
