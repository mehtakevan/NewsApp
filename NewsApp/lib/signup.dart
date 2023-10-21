import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:login/signin.dart';
import 'loading.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _already() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }
  void _signUp() async {
    String email = _emailController.text.trim();
    String pass = _passwordController.text.trim();
    String cPass = _confirmPasswordController.text.trim();

    if(email == ""){
      log("Please Provide Email");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please Provide Email'),
            duration: Duration(seconds: 4),
          )
      );
    }
    else if(pass == "" || cPass == ""){
      log("Please Provide Password");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please Provide Password'),
            duration: Duration(seconds: 4),
          )
      );
    }
    else if(pass != cPass){

      log("Password and confirm password is not matching please check it correctly");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password and confirm password is not matching please check it correctly'),
            duration: Duration(seconds: 4),
          )
      );
    }
    else if(pass.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Password must be equal or greater than 6'),
            duration: Duration(seconds: 4),
          )
      );
    }
    else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen(email,pass,1)),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(26.0),
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
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password must contain 6 characters',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password',
                hintText: 'Provide the same password u provided above'
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _already,
              child: Text('Already have an account ?'),
            ),
          ],
        ),
      ),
    );
  }

}