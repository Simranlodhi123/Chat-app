import 'package:Whatschat/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() { 
   WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(new MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     Firebase.initializeApp();
    return  MaterialApp(
     
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
 var fb=Firebase.initializeApp();

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
    resizeToAvoidBottomPadding: false,
   
     body:
              LoginScreen2(), 
  
    
    );
  }

     
  }
