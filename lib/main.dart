import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'Pages/SettingsPage.dart';
import 'Pages/BookmarksPage.dart';
import 'Data/SharedPref.dart';
import 'Controllers/ThemeBloc.dart';
import 'package:flutter/rendering.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

@immutable
class MyApp extends StatefulWidget {
  @override
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  SharedPreferencesProvider prefs = SharedPreferencesProvider();
  final themeBloc = ThemeBloc();
  final cardViewBloc = CardViewBloc();

  bool? firstStart;
  bool darkMode = true;
  bool cardView = true;

  @override
  void initState() {
    super.initState();
    initPreferences();
  }

  void initPreferences() async {
    firstStart = await prefs.getFirstStart();
    List<String> likedList = [];

    if (firstStart == null) {
      prefs.setFirstStart();
      prefs.setLiked(likedList);
      prefs.setTheme(true);
      prefs.setCardView(true);
    }

    darkMode = await prefs.getTheme();
    cardView = await prefs.getCardView();
    themeBloc.setDarkMode(darkMode);
    cardViewBloc.setCardView(cardView);
  }

  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    // primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    // accentColor: Colors.white,
    // accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.blue[800],
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
    return StreamBuilder(
      stream: themeBloc.darkMode,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot1) {
        return StreamBuilder(
            stream: cardViewBloc.cardView,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot2) {
              Brightness _brightness = Brightness.dark;
              if (snapshot1.data == false) {
                _brightness = Brightness.light;
              }
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Home(cardView: snapshot2.data),
                theme: snapshot1.data == true ? darkTheme : lightTheme,
              );
            });
      },
    );
  }
}

class Home extends StatefulWidget {
  bool? cardView;

  Home({Key? key, this.cardView}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is signed out!');
        setState(() => _user = user);
      } else {
        print('User is signed in!');
        setState(() => _user = user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(children: <Widget>[
          HomePage(user: _user, cardView: widget.cardView),
          SettingsPage(user: _user, auth: _auth, cardView: widget.cardView),
          BookMarksPage(user: _user, cardView: widget.cardView),
        ]),
        bottomNavigationBar: SafeArea(
          child: Container(
            child: TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'Home',
                  icon: Icon(Icons.home),
                ),
                Tab(
                  text: 'Settings',
                  icon: Icon(Icons.settings),
                ),
                Tab(
                  text: 'Bookmarks',
                  icon: Icon(Icons.bookmark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
