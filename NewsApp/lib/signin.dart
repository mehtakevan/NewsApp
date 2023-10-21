import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/signup.dart';

import 'homeScreen.dart';
import 'loading.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  void _signUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String pass = _passwordController.text.trim();

    try{
      if(email == ""){
        log("Please Provide Email");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please Provide Email'),
              duration: Duration(seconds: 4),
            )
        );
      }
      else if(pass == ""){
        log("Please Provide Password");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please Provide Password'),
              duration: Duration(seconds: 4),
            )
        );
      }
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoadingScreen(email,pass,2)),
        );
      }
    }
    catch(e){
      _passwordController.clear();
      _emailController.clear();
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: Duration(seconds: 4),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email',
                hintText: 'abc@gmail.com',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password',
                hintText: 'Password must contain 6 characters',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Create a New Account !!'),
            ),
          ],
        ),
      ),
    );
  }
}