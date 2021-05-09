import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {

  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();

  String messageText;
  final _auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
   await for( var snapshot in _firestore.collection('messages').snapshots()) {
     for (var message in snapshot.docs) {
       print(message.data().cast());
     }
   }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
              }),
        ],
        title: Text('⚡️Bolt'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'timestamp': FieldValue.serverTimestamp(),
                        'text':messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle.copyWith(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          final  messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBlubbles = [];

          for (var message in messages){

            final messageText = message.get('text');
            final messageSender = message.get('sender');

            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );

            messageBlubbles.add(messageBubble);

          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBlubbles,
            ),
          );
        };
      },
    );
  }
}


class MessageBubble extends StatelessWidget{

  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(
            fontSize: 12.0,
            color: Colors.white12,
          ),),
          Material(
              borderRadius: isMe ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)
              ):
              BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)
              ) ,
              elevation: 5.0,
              color: isMe ? Colors.blueAccent : Colors.white24,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0,),
                child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                 ),
                ),
              ),
            ),
         ],
       ),
     );
   }
}