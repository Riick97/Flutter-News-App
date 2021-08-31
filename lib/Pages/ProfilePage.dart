import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  User? user;
  FirebaseAuth? auth;

  ProfilePage({Key? key, this.user, this.auth}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool eye = true;
  User? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Text(
                "My Profile",
                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              new SizedBox(
                height: 70,
              ),
              Text(user == null
                  ? 'Not signed in'
                  : '${user!.isAnonymous ? 'User is anonymous\n\n' : ''}'
                      'Email: ${user!.email} (verified: ${user!.emailVerified})\n\n'
                      'Phone number: ${user!.phoneNumber}\n\n'
                      'Name: ${user!.displayName}\n\n\n'
                      'ID: ${user!.uid}\n\n'
                      'Tenant ID: ${user!.tenantId}\n\n'
                      'Refresh token: ${user!.refreshToken}\n\n\n'
                      'Created: ${user!.metadata.creationTime.toString()}\n\n'
                      'Last login: ${user!.metadata.lastSignInTime}\n\n'),
              new SizedBox(
                height: 30,
              ),
              new SizedBox(
                height: 50,
                child: new RaisedButton(
                    child: new Text(
                      "Sign out",
                    ),
                    elevation: 15.0,
                    shape: StadiumBorder(),
                    onPressed: () async {
                      await widget.auth!.signOut();
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => LoginPage(),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
