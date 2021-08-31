import 'package:flutter/material.dart';
import 'package:flutter_news/Models/NewsApiResponseModel.dart';
import './SearchList.dart';
import '../Controllers/ArticlesBloc.dart';

class Results extends StatelessWidget {
  Results({
    @required this.controller,
    @required this.bloc,
  });

  final TextEditingController? controller;
  final ArticleCollectionBloc? bloc;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(vertical: 20.0);
    return StreamBuilder(
      stream: bloc!.articles,
      builder: (BuildContext context, AsyncSnapshot<NewsApiResonse> snapshot) {
        if (snapshot.hasData) {
          // Build list of search results.
          return SearchList(snapshot.data!.articles!, padding: padding);
        }
        // Return placeholder skeleton.
        if (controller!.value.text.isNotEmpty) {
          return SearchList.skeleton();
        }
        // Show empty container if there is no current query.
        return Container(padding: padding);
      },
    );
  }
}
