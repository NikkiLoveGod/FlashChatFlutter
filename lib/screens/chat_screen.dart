import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var messageStream = _firestore.collection('messages').snapshots();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User loggedInUser;
  bool isLoading = false;
  String message;

  @override
  void initState() {
    super.initState();
    this.getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = this._auth.currentUser;

      if (user != null) {
        this.loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future logout() async {
    setState(() {
      this.isLoading = true;
    });
    try {
      this._auth.signOut();
      await Future.delayed(Duration(milliseconds: 400));
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
    setState(() {
      this.isLoading = false;
    });
  }

  Future sendMessage() async {
    setState(() {
      this.isLoading = true;
    });
    try {
      await _firestore
          .collection('messages')
          .add({'text': this.message, 'sender': this._auth.currentUser.email});
    } catch (e) {
      print(e);
    }
    setState(() {
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: this.logout,
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: this.isLoading,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (context, snapshot) {
                    List<Widget> messages = [];
                    if (snapshot.hasData) {
                      snapshot.data.docs.forEach(
                        (DocumentSnapshot s) {
                          print(s);
                          messages.add(
                            Text(s['text']),
                          );
                        },
                      );
                    }

                    return Column(
                      children: messages,
                    );
                  },
                ),
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          this.message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: this.sendMessage,
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
