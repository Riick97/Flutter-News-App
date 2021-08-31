import 'package:flutter/material.dart';
import 'package:flutter_news/Widgets/NewsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SearchPage.dart';

import '../Controllers/ThemeBloc.dart';

class HomePage extends StatefulWidget {
  User? user;
  bool? cardView;

  HomePage({Key? key, this.user, this.cardView}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<Tab> newsTabs = <Tab>[
    new Tab(text: 'general'),
    new Tab(text: 'technology'),
    new Tab(text: 'business'),
    new Tab(text: 'entertainment'),
    new Tab(text: 'health'),
    new Tab(text: 'sports'),
    new Tab(text: 'science'),
  ];

  TabController? _tabController;
  final sortBloc = SortBloc();
  String _sort = 'empty';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: newsTabs.length);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Future<void> _sortOptions() async {
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Sort by:'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'ascending');
                },
                child: _sort == 'published_asc'
                    ? Text('Latest',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold))
                    : Text('Latest'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'descending');
                },
                child: _sort == 'published_desc'
                    ? Text('Oldest',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold))
                    : Text('Oldest'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'popularity');
                },
                child: _sort == 'empty'
                    ? Text('Most Popular',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold))
                    : Text('Most Popular'),
              ),
            ],
          );
        })) {
      case 'ascending':
        setState(() {
          _sort = 'published_asc';
        });
        sortBloc.setSort(_sort);
        break;
      case 'descending':
        setState(() {
          _sort = 'published_desc';
        });
        sortBloc.setSort(_sort);
        break;
      case 'popularity':
        setState(() {
          _sort = 'empty';
        });
        sortBloc.setSort(_sort);
        break;
      case null:
        // dialog dismissed
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
        bottom: TabBar(
          tabs: newsTabs,
          isScrollable: true,
          controller: _tabController,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              child: Icon(
                Icons.search,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _sortOptions();
              },
              child: Icon(
                Icons.sort,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: newsTabs.map((Tab tab) {
          return NewsList(
              category: tab.text!,
              sort: _sort,
              user: widget.user,
              cardView: widget.cardView);
        }).toList(),
      ),
    );
  }
}
