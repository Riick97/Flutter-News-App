import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SignUpPage.dart';
import 'ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool eye = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              ProfilePage(user: user, auth: _auth),
        ),
      );
      print('User ${user!.email} signed in');
    } catch (e) {
      print('Failed to sign in with Email & Password');
    }
  }

  void _toggle() {
    setState(() {
      eye = !eye;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.0,
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
            child: new FlatButton(
              child: new Text(
                "Sign up",
                style: new TextStyle(fontSize: 17),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              // highlightColor: Colors.black,
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Form(
            key: _formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Text(
                  "Log in",
                  style:
                      new TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                new SizedBox(
                  height: 70,
                ),
                new TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: new InputDecoration(
                    // hintText: "Email",
                    labelText: "Email",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) return 'Please enter some text';
                    return null;
                  },
                ),
                new SizedBox(
                  height: 30,
                ),
                new TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  decoration: new InputDecoration(
                    labelText: "Password",
                    suffixIcon: new GestureDetector(
                      child: new Icon(
                        Icons.remove_red_eye,
                      ),
                      onTap: _toggle,
                    ),
                  ),
                  obscureText: eye,
                  validator: (String? value) {
                    if (value!.isEmpty) return 'Please enter some text';
                    return null;
                  },
                ),
                new SizedBox(
                  height: 30,
                ),
                new SizedBox(
                  height: 50,
                  child: new RaisedButton(
                    child: new Text(
                      "Log in",
                    ),
                    elevation: 15.0,
                    shape: StadiumBorder(),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _signInWithEmailAndPassword();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
