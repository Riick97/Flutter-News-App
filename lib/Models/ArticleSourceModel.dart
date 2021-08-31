import 'dart:convert';

class ArticleSource {
  String? id;
  String? name;

  ArticleSource({
    this.id,
    this.name,
  });

  factory ArticleSource.fromRawJson(String str) =>
      ArticleSource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArticleSource.fromJson(Map<String, dynamic> json) => ArticleSource(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
