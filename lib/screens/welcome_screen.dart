import 'package:flash_chat/components/round_button.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    this.controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    this.animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(this.controller);

    this.controller.forward();

    this.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this.animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 80.0,
                    width: 80.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  speed: Duration(milliseconds: 100),
                  textStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Hero(
              tag: 'login-btn',
              child: RoundedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                text: 'Log In',
                color: Colors.lightBlueAccent,
              ),
            ),
            Hero(
              tag: 'register-btn',
              child: RoundedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                text: 'Register',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
