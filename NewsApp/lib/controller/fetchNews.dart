  // https://newsapi.org/v2/top-headlines?sources=google-news-in&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f
  import 'dart:convert';
  import 'dart:math';
  import 'package:http/http.dart';
  import 'package:login/model/newsArt.dart';

  class FetchNews {
    static List sourcesId = [
      "abc-news",

      "bbc-news",
      "bbc-sport",

      "business-insider",

      "engadget",
      "entertainment-weekly",
      "espn",
      "espn-cric-info",
      "financial-post",

      "fox-news",
      "fox-sports",
      "globo",
      "google-news",
      "google-news-in",

      "medical-news-today",

      "national-geographic",

      "news24",
      "new-scientist",

      "new-york-magazine",
      "next-big-future",

      "techcrunch",
      "techradar",

      "the-hindu",

      "the-wall-street-journal",

      "the-washington-times",
      "time",
      "usa-today",

    ];
    static String news = '';
    static String getSelectedNews() {
      final _random = new Random();
      return sourcesId[_random.nextInt(sourcesId.length)];
    }
    static String getNews(){
      return news;
    }

    static Future<NewsArt> fetchNews() async {
       news = getSelectedNews();


      Response response = await get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?sources=$news&apiKey=caea254bf2f94f869e831ec24284ece1"));

      Map body_data = jsonDecode(response.body);
      List articles = body_data["articles"];

      final _Newrandom = new Random();
      var myArticle = articles[_Newrandom.nextInt(articles.length)];


      return NewsArt.fromAPItoApp(myArticle);
    }

    static Future<NewsArt> forsubscriber(String name) async {
      news = name;


      Response response = await get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?sources=$news&apiKey=caea254bf2f94f869e831ec24284ece1"));

      Map body_data = jsonDecode(response.body);
      List articles = body_data["articles"];

      final _Newrandom = new Random();
      var myArticle = articles[_Newrandom.nextInt(articles.length)];


      return NewsArt.fromAPItoApp(myArticle);
    }
  }
