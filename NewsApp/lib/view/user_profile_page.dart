import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/view/NewsDetailPage.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<String> subscribedNews = [];

  @override
  void initState() {
    super.initState();
    // Fetch and load the subscribed news when the user profile page is opened
    loadSubscribedNews();
  }



  Future<void> loadSubscribedNews() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle not being logged in
      return;
    }

    final userCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = userCollection.doc(user.uid);

    final userData = await userDoc.get();
    if (userData.exists) {
      setState(() {
        subscribedNews = List<String>.from(userData.get('subscribedNews'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Subscribed News:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            // Display the subscribed news as a list with decoration
            if (subscribedNews.isNotEmpty)
              Expanded(
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subscribedNews.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3, // Add elevation (a shadow) to the card
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Add rounded corners to the card
                        ),
                        color: Colors.lightBlue, // Background color for each list item
                        child: ListTile(
                          title: Text(
                            subscribedNews[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            // When an item is tapped, navigate to the news detail page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailPage(subscribedNews[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (subscribedNews.isEmpty)
              Text('No subscribed news yet.'),
          ],
        ),
      ),
    );
  }
}
