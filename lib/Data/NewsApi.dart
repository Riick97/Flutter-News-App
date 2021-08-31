import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../Models/NewsApiResponseModel.dart';

class NewsApi {
  final apiKey = '260a8f652b154e80302d88681b23cf6d';
  String testUrl =
      'http://api.mediastack.com/v1/news?access_key=260a8f652b154e80302d88681b23cf6d&offset=0&languages=en&categories=general&limit=25&sort=default';

  static Future<NewsApiResonse?> fetchNews(
      {String category: 'general',
      int offset: 0,
      String keywords: 'empty',
      String sort: 'empty'}) async {
    String sortArg = sort != 'empty' ? 'sort=$sort' : '';
    String keywordsArg = keywords != 'empty' ? 'keywords=$keywords' : '';

    var url = Uri.parse(
        "http://api.mediastack.com/v1/news?access_key=260a8f652b154e80302d88681b23cf6d&offset=$offset&languages=en&categories=$category&limit=25&$sortArg&$keywordsArg");
    var client = http.Client();
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      return NewsApiResonse.fromJson(jsonMap, response.reasonPhrase);
    }
    return null;
  }
}
