import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/signup.dart';
import 'firebase_options.dart';
import 'homeScreen.dart';
import 'loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Example',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: SignUpPage(),
    );
  }
}

