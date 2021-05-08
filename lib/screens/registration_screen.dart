import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {

  static const String id = 'registration_screen';


  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with SingleTickerProviderStateMixin {

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  String email;
  String password;

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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo' ,
                child:Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter Your Email' ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                  textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: KTextFieldDecoration.copyWith(hintText: 'Enter a 6digit Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
             RoundedButton(
               title:'Register',
               colour: Colors.blueAccent,
               onPressed:() async {
                 setState(() {
                   showSpinner = true;
                 });
                 try{
                 final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                 if(newUser != null){
                   Navigator.pushNamed(context, ChatScreen.id);
                 }
                 setState(() {
                   showSpinner = false;
                 });
               }
               catch (e) {
                   print(e);
               }
               }

               )
            ],
          ),
        ),
      ),
    );
  }
}
