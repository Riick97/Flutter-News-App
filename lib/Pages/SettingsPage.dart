import 'package:flutter/material.dart';
import 'package:flutter_news/Pages/ProfilePage.dart';
import '../Controllers/ThemeBloc.dart';
import 'LoginPage.dart';
import '../Data/SharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  User? user;
  FirebaseAuth? auth;
  bool? cardView;

  SettingsPage({Key? key, this.user, this.auth, this.cardView})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferencesProvider prefs = SharedPreferencesProvider();
  final themeBloc = ThemeBloc();
  final cardViewBloc = CardViewBloc();

  bool darkTheme = false;
  bool? initData;

  @override
  void initState() {
    initStateCustom().then((_) {
      setState(() {});
    });
    super.initState();
    themeBloc.darkMode.asBroadcastStream().listen((event) {
      print('activated');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Init state logic
  Future initStateCustom() async {
    darkTheme = await prefs.getTheme();
    initData = true;
  }

  changeTheme(value) async {
    themeBloc.setDarkMode(value);
    await prefs.setTheme(value);
  }

  changeView(value) async {
    cardViewBloc.setCardView(value);
    await prefs.setCardView(value);
  }

  @override
  Widget build(BuildContext context) {
    if (initData == false || initData == null) {
      print(initData);
      return LinearProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.person,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              // onTap: () => changeTheme(!darkTheme),
              title: Text('Dark theme'),
              subtitle: Text('Enable dark theme throughout the app'),
              trailing: Switch(
                activeColor: Theme.of(context).accentColor,
                onChanged: (bool value) => changeTheme(value),
                value: Theme.of(context).brightness == Brightness.dark
                    ? true
                    : false,
              ),
            ),
            Divider(),
            ListTile(
              onTap: () => {},
              title: Text('Card view'),
              subtitle: Text('Enable card view for news lists'),
              trailing: Switch(
                activeColor: Theme.of(context).accentColor,
                onChanged: (bool value) {
                  changeView(value);
                },
                value: widget.cardView!,
              ),
            ),
            Divider(),
            ListTile(
              title: Text('My Account'),
              subtitle: Text('See Account Information'),
              onTap: () => {
                if (widget.user != null)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                              user: widget.user, auth: widget.auth)),
                    )
                  }
                else
                  {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      )
                    }
                  }
              },
            ),
            Divider(), // Divider
          ],
        ),
      ),
    );
  }
}
