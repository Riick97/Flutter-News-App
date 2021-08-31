import 'package:flutter/material.dart';
import '../Models/ArticleModel.dart';
import './ArticleTile.dart';

class SearchList extends StatelessWidget {
  final List<Article>? articles;
  final int? itemCount;
  final EdgeInsetsGeometry? padding;

  SearchList(
    this.articles, {
    this.itemCount,
    this.padding: const EdgeInsets.symmetric(vertical: 20.0),
  });

  SearchList.skeleton({
    this.itemCount,
    this.padding: const EdgeInsets.symmetric(vertical: 20.0),
  }) : articles = null;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: itemCount ?? articles!.length,
      padding: padding,
      separatorBuilder: (BuildContext context, int index) {
        return articles![index].urlToImage == null
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(),
              );
      },
      itemBuilder: (BuildContext context, int index) {
        // Return regular tile with content.
        return articles![index].urlToImage == null
            ? Container()
            : ArticleTile.fromArticleModel(
                articles![index],
                context,
              );
      },
    );
  }
}
