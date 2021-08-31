import 'package:flutter/material.dart';
import '../Models/ArticleModel.dart';
import './PlaceHolderImage.dart';
import '../Pages/ArticlePage.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleTile extends StatelessWidget {
  final Article? article;
  final Widget? title;
  final Widget? thumbnail;
  final Widget? published;

  ArticleTile({
    this.article,
    this.title,
    this.thumbnail,
    this.published,
  });

  ArticleTile.fromArticleModel(Article article, BuildContext context)
      : article = article,
        title = Text(cleanTitle(article.title!),
            style: Theme.of(context).textTheme.body1!.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                )),
        thumbnail = article.urlToImage != null
            ? FadeInImage.memoryNetwork(
                image: article.urlToImage!,
                placeholder: kTransparentImage,
                fit: BoxFit.cover,
              )
            : ImagePlaceholder('No image.'),
        published = Text(
          _timestamp(article.publishedAt!),
          style: Theme.of(context).textTheme.subtitle!.copyWith(
                fontSize: 14.0,
                color: Colors.blue,
              ),
        );

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticlePage(
            postUrl: article!.url,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: _compactTile(),
      ),
    );
  }

  Widget _compactTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: published),
              title!,
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AspectRatio(
                    aspectRatio: 1.0 / 1.0,
                    child: Container(color: Colors.black26)),
                AspectRatio(aspectRatio: 1.0 / 1.0, child: thumbnail),
              ],
            ),
          ),
        )
      ],
    );
  }

  static String cleanTitle(String originalTitle) {
    List<String> split = originalTitle.split(' - ');
    return split[0];
  }

  /// Returns the article's published date in a readable
  /// form.
  static String _timestamp(DateTime oldDate) {
    String timestamp;
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(oldDate);
    if (difference.inSeconds < 60) {
      timestamp = 'Now';
    } else if (difference.inMinutes < 60) {
      timestamp = '${difference.inMinutes}M';
    } else if (difference.inHours < 24) {
      timestamp = '${difference.inHours}H';
    } else {
      timestamp = '${difference.inDays}D';
    }

    return timestamp;
  }
}
