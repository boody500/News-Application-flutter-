import 'package:flutter/material.dart';
import '../services/news_service_api.dart';
import '../model/news.dart';

class NewsProviderApi with ChangeNotifier {

  String query = "";
  List<News> news = [];
  List<News> Topnews = [];

  bool isLoading = true;

  List<News> get getNews => news;
  List<News> get getTopNews => Topnews;

  bool get IsLoading => isLoading;

  NewsProviderApi() {
    fetchTopNews();

  }

  Future<void> fetchNews(String search_query) async {
    try {
      isLoading = true;
      notifyListeners();
      query = search_query;
      news = await NewsService().fetchNews(query);
      print(news.runtimeType);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      // Handle the error, show it in the UI if needed
      print('Error fetching news: $e');
      notifyListeners();
    }
  }

  Future<void> fetchTopNews() async {
    try {
      isLoading = true;
      notifyListeners();
      Topnews = await NewsService().fetchTopNews();
      print(Topnews.runtimeType);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      // Handle the error, show it in the UI if needed
      print('Error fetching news: $e');
      notifyListeners();
    }
  }

  void clearSearchNews(){
    news.clear();
  }





}
