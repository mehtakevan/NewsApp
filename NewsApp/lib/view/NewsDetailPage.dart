import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/view/user_profile_page.dart';
import 'package:login/view/widget/NewsContainer.dart';
import '../controller/fetchNews.dart';
import '../model/newsArt.dart';

class NewsDetailPage extends StatefulWidget {
  final String newsTitle;

  NewsDetailPage(this.newsTitle);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late NewsArt newsArt;
  bool isLoading = true;
  GetNews() async {
    newsArt = await FetchNews.forsubscriber(widget.newsTitle);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    GetNews();
  }

  Future<void> unsubscribeFromNews(String news) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Not logged in
        return;
      }

      final userCollection = FirebaseFirestore.instance.collection('users');
      final userDoc = userCollection.doc(user.uid);

      // Get the user's data to check if they have subscribed
      final userData = await userDoc.get();
      final subscribedNews = List<String>.from(userData.get('subscribedNews'));

      if (!subscribedNews.contains(news)) {
        // User is not subscribed to this news

        final snackBar = SnackBar(
          content: Text('You are not subscribed to this news.'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // User has subscribed, so update the subscribedNews array to remove the news
        await userDoc.update({
          'subscribedNews': FieldValue.arrayRemove([news]),
        });

        // Show a SnackBar message to confirm the unsubscription
        final snackBar = SnackBar(
          content: Text('You have unsubscribed from the news.'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e, stackTrace) {
      // Handle the exception, print it, or show an error message
      print("An error occurred: $e");
      print("Stack trace: $stackTrace");
    }
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
              unsubscribeFromNews(widget.newsTitle);
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.remove_circle),
                Text('UnSubscribe'),
              ],
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: PageController(initialPage: 0),
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
