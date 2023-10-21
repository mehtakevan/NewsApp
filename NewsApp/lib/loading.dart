import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/news.dart';
import 'package:login/signin.dart';
import 'dart:developer';
import 'package:login/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homeScreen.dart';



class LoadingScreen extends StatefulWidget {
  String email;
  String pass;
  int x;
  LoadingScreen(this.email, this.pass, this.x);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // Simulate a delay for verification (replace with your actual verification logic)

  Future<void> createUserDocument(User user) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = userCollection.doc(user.uid);

    // Check if the document already exists
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      // Document doesn't exist, create it
      await userDoc.set({
        'subscribedNews': <String>[], // Initialize with an empty list
      });
    }
  }


  Future<void> verifyAccount() async {
    try{
      UserCredential userAccount = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: widget.email, password: widget.pass);
      log("account created!");
      if(userAccount.user != null){
        await createUserDocument(userAccount.user!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    }
    on FirebaseAuthException catch(e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: Duration(seconds: 4),
          )
      );
      Navigator.pushReplacement(
          context ,
          MaterialPageRoute(builder: (context) => SignUpPage()
          )
      );
    } // Simulated delay
  }

  Future<void> signin() async {
    try{
      UserCredential userAccount = await FirebaseAuth.instance.signInWithEmailAndPassword(email: widget.email, password: widget.pass);
      if(userAccount.user != null){

        Navigator.pushReplacement(
            context ,
            MaterialPageRoute(builder: (context) => News(widget.email)
            )
        );
      }
    }
    on FirebaseAuthException catch(e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: Duration(seconds: 4),
          )
      );
      Navigator.pushReplacement(
          context ,
          MaterialPageRoute(builder: (context) => SignInPage()
          )
      );
    } // Simulated delay
  }



  @override
  void initState() {
    super.initState();
    if(widget.x == 1){
      verifyAccount();
    }
    else if(widget.x == 2){
      signin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Loading animation
            SizedBox(height: 16.0),
            Text(
              widget.x == 1 ? 'Signing Up...' : 'Logging In...',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),// Loading animation
      ),
    );
  }
}

