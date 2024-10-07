import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/news.dart';

class NewsService {
  String endpoint = 'everything';
  String query = 'flutter';
  String apiKey = 'f35c92550d674159b666a1640b36c0dc';
  final String _baseUrl = 'https://newsapi.org/v2/';
  // Fetch list of albums
   fetchNews(String search_query) async {
    try{
      print(_baseUrl+endpoint+"?q=$query"+"&apiKey=$apiKey");
      if(search_query != "")
        query = search_query;
      final response = await http.get(Uri.parse(_baseUrl+endpoint+"?q=$query"+"&language=en"+"&apiKey=$apiKey"));


      Map<String,dynamic> body = json.decode(response.body);
      List articles = body['articles'];
      List<News> newslist = [];
      for(int i = 0; i < articles.length;i++){
        var item = News.fromJson(articles[i]);
        if(item.title != "[Removed]") {
          newslist.add(item);
        }
      }
      return newslist;
    }
    catch(e){
      print(e);
    }



  }

  fetchTopNews() async{
     endpoint = "top-headlines";


     try{
       print(_baseUrl+endpoint+"?&country=us"+"&apiKey=$apiKey");

       final response = await http.get(Uri.parse(_baseUrl+endpoint+"?country=us"+"&apiKey=$apiKey"));
        print(response.body);

       Map<String,dynamic> body = json.decode(response.body);
       List articles = body['articles'];
       List<News> newslist = [];
       for(int i = 0; i < articles.length;i++){
         var item = News.fromJson(articles[i]);
         if(item.title != "[Removed]") {
           newslist.add(item);
         }
       }
       return newslist;
     }
     catch(e)
     {
       print(e);
     }
}

}
