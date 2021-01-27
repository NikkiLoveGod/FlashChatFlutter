import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/round_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                this.email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
              ),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                this.password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password.',
              ),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Hero(
              tag: 'login-btn',
              child: RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  try {
                    final user = await this._auth.signInWithEmailAndPassword(
                          email: this.email,
                          password: this.password,
                        );
                    if (user != null) {
                      return Navigator.pushNamed(context, ChatScreen.id);
                    }

                    print('signin is null');
                  } catch (e) {
                    print(e);
                  }
                },
                text: 'Log In',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
