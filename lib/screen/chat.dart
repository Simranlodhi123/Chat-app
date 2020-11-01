import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var fires = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
 
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messCon = TextEditingController();
  final authc = FirebaseAuth.instance;

  String message;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await authc.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        actions: <Widget>[
         
              IconButton(icon: Icon(Icons.person), onPressed:(){print('hello');}),
               IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                authc.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('WhatsChat'),
        backgroundColor: Colors.green.shade600
      ),
      body: SafeArea(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Messages(),
            Container(
              decoration:BoxDecoration(
                color: Colors.blueGrey.shade200,
  border: Border(
    top: BorderSide(color: Colors.black87, width: 2.0),
  ),
),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messCon,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messCon.clear();
                      fires.collection('chat_ss').add({
                        'text': message,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Enter'??'send',
                      style:TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
),
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

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fires.collection('chat_ss').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.cyan,
            ),
          );
        }
        final msg = snapshot.data.docs.reversed;
        List<GetMsg> getmess = [];
        for (var message in msg) {
          var msgTxt = message.data()['text'];
          var msgsndr = message.data()['sender'];

          var currentUser = loggedInUser.email;

          var msgB = GetMsg(
            sender: msgsndr,
            text: msgTxt,
            isMe: currentUser == msgsndr,
          );

          getmess.add(msgB);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: getmess,
          ),
        );
      },
    );
  }
}

class GetMsg extends StatelessWidget {
  GetMsg({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: 
      Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            color: Colors.red.shade300,
            child:
          Text(
            sender??'sender',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),),
          SizedBox(
            height: 1,
          ),
          Material(
          
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text??'text',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}