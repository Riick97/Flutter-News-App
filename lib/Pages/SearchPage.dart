import 'package:flutter/material.dart';
import '../Controllers/ArticlesBloc.dart';
import '../Widgets/SearchField.dart';
import '../Widgets/Results.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textController = TextEditingController();
  final searchBloc = ArticleCollectionBloc();

  void _handleChange(String value) async {
    if (value.isNotEmpty) {
      final String query = value;
      await Future.delayed(Duration(milliseconds: 500));
      if (query == textController.value.text) {
        searchBloc.searchArticles(query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            brightness: Theme.of(context).brightness,
            centerTitle: true,
            floating: true,
            pinned: true,
            title: Text('Search'),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            // App bar bottom containing search field.
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 73.0),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 16.0),
                child: SearchField(
                  controller: textController,
                  onChanged: (value) => _handleChange(value),
                ),
              ),
            ),
          ),

          // List of search results.
          SliverList(
            delegate: SliverChildListDelegate([
              Results(bloc: searchBloc, controller: textController),
            ]),
          ),
        ],
      ),
    );
  }
}
