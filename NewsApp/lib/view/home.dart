import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/controller/fetchNews.dart';
import 'package:login/model/newsArt.dart';
import 'package:login/view/widget/NewsContainer.dart';
import 'package:login/view/user_profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  late NewsArt newsArt;
  String news = '';

  GetNews() async {
    newsArt = await FetchNews.fetchNews();
    news = FetchNews.getNews();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> subscribeToNews() async {

    try {
      print("Hello1");
      final user = FirebaseAuth.instance.currentUser;
      print("Hello2");
      if (user == null) {
        print("NOt LOGGED IN");
        return;
      }
      print(user.uid);

      final userCollection = FirebaseFirestore.instance.collection('users');
      print("Hello3");
      final userDoc = userCollection.doc(user.uid);
      print("Hello4");

      // Get the user's data to check if they have already subscribed
      print(userDoc);
      final userData = await userDoc.get();
      print("Hello5");
      final subscribedNews = List<String>.from(userData.get('subscribedNews'));
      print("Hello6");
      print(news);
      if (subscribedNews.contains(news)) {
        // User has already subscribed to this news

        final snackBar = SnackBar(
          content: Text('You are already subscribed to this news.'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // User has not subscribed yet, so update the subscribedNews array
        await userDoc.update({
          'subscribedNews': FieldValue.arrayUnion([news]),
        });

        // Show a SnackBar message to confirm the subscription
        final snackBar = SnackBar(
          content: Text('You have successfully subscribed to the news!'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    catch (e, stackTrace) {
      // Handle the exception, print it, or show an error message
      print("An error occurred: $e");
      print("Stack trace: $stackTrace");
    }
  }


  @override
  void initState() {
    GetNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.person),
                Text('Profile'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              subscribeToNews();
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.add),
                Text('Subscribe'),
              ],
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.vertical,
        onPageChanged: (value) {
          setState(() {
            isLoading = true;
          });
          GetNews();
        },
        itemBuilder: (context, index) {
          return isLoading
              ? Center(child: CircularProgressIndicator())
              : NewsContainer(
            imgUrl: newsArt.imgUrl,
            newsCnt: newsArt.newsCnt,
            newsHead: newsArt.newsHead,
            newsDes: newsArt.newsDes,
            newsUrl: newsArt.newsUrl,
          );
        },
      ),
    );
  }
}
