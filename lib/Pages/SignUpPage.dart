import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool eye = true;
  bool? _success;
  String _userEmail = '';
  User? _user;

  void _toggle() {
    setState(() {
      eye = !eye;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  Future<void> _register() async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email!;
        _user = user;
      });
    } else {
      _success = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: new AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: new SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: new Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Text(
                  "Sign up",
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
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                new SizedBox(
                  height: 30,
                ),
                new TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  decoration: new InputDecoration(
                    // hintText: "Email",
                    labelText: "Name",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
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
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_success == null
                      ? ''
                      : (_success!
                          ? 'Successfully registered $_userEmail'
                          : 'Registration failed')),
                ),
                new SizedBox(
                  height: 60,
                ),
                new SizedBox(
                  height: 50,
                  child: new RaisedButton(
                    child: new Text(
                      "Sign up",
                      // style: new TextStyle(color: Colors.black),
                    ),
                    // color: Colors.white,
                    elevation: 15.0,
                    shape: StadiumBorder(),
                    splashColor: Colors.white54,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _register();
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ProfilePage(user: _user, auth: _auth),
                          ),
                        );
                      }
                    },
                  ),
                ),
                new SizedBox(height: 60),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("By signing up you agree to our "),
                    new GestureDetector(
                        child: Text("Terms of Use",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            )),
                        onTap: () {})
                  ],
                ),
                new SizedBox(
                  height: 5,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("and "),
                    new GestureDetector(
                        child: Text("Privacy Policy",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            )),
                        onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
