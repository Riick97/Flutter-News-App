import 'dart:developer';

import 'ArticleModel.dart';
import 'dart:convert';

class NewsApiResonse {
  String? status;
  List<Article>? articles;

  NewsApiResonse({
    this.status,
    this.articles,
  });

  factory NewsApiResonse.fromRawJson(String str, status) =>
      NewsApiResonse.fromJson(json.decode(str), status);


  factory NewsApiResonse.fromJson(Map<String, dynamic> json, status) => NewsApiResonse(
        status: status == null ? null : status,
        articles: json['data'] == null
            ? null
            : List<Article>.from(
                json["data"].map((article) => Article.fromJson(article))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "articles": articles == null
            ? null
            : List<dynamic>.from(articles!.map((x) => x.toJson())),
      };

  String toRawJson() => json.encode(toJson());

}
