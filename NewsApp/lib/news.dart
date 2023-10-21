import 'package:flutter/material.dart';
import 'package:login/view/home.dart';
import 'dart:developer';

import 'package:login/view/spalsh.dart';

class News extends StatefulWidget {
  const News(String email, {super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool showingSplash = true;
  LoadHome() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showingSplash = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadHome();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Snack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: showingSplash ? SplashScreen() : HomeScreen(),
    );
  }
}