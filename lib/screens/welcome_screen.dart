import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/RoundedButton.dart';

import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {

  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(seconds: 1), vsync: this,);

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.black54).animate(controller);

    controller.forward();

    controller.addListener(() {setState(() {});});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
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
                  child:Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                // ignore: deprecated_member_use
                TypewriterAnimatedTextKit(
                  text: ['Thunder Bolt'],
                  textStyle: TextStyle(
                    color: Colors.white60,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                    speed: const Duration(milliseconds: 180)
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log in', colour: Colors.lightBlueAccent, onPressed: () {
            Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(title: 'Register', colour: Colors.blueAccent, onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
            ),
          ],
        ),
      ),
    );
  }
}
