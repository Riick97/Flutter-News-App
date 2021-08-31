import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromRawJson(String str) => Article.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: json["source"] == null ? null : json["source"],
        author: json["author"] == null ? null : json["author"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        url: json["url"] == null ? null : json["url"],
        urlToImage: json["image"] == null ? null : json["image"],
        publishedAt: json["published_at"] == null
            ? null
            : DateTime.parse(json["published_at"]),
        content: json["content"] == null ? null : json["content"],
      );

  factory Article.fromSnapshot(DocumentSnapshot doc) => Article(
        source: null,
        author: null,
        title: doc["title"] == null ? null : doc["title"],
        description: doc["description"] == null ? null : doc["description"],
        url: doc["url"] == null ? null : doc["url"],
        urlToImage: doc["image"] == null ? null : doc["image"],
        publishedAt: null,
        content: doc["content"] == null ? null : doc["content"],
      );

  Map<String, dynamic> toJson() => {
        "source": source == null ? null : source,
        "author": author == null ? null : author,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "url": url == null ? null : url,
        "image": urlToImage == null ? null : urlToImage,
        "publishedAt":
            publishedAt == null ? null : publishedAt!.toIso8601String(),
        "content": content == null ? null : content,
      };

  String getTime() {
    var formatter = new DateFormat('dd MMMM yyyy h:m');
    String formatted = formatter.format(publishedAt!);
    return formatted;
  }

  String getDateOnly() {
    var formatter = new DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(publishedAt!);
    return formatted;
  }
}
