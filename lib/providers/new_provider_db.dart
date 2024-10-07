import 'package:flutter/cupertino.dart';
import 'package:hagora/model/news.dart';
import '../services/news_service_db.dart';

class NewsProviderDb with ChangeNotifier {

  static List<News>newsLocal=[];
  List<News> get getNewsLocal => newsLocal;
  NewsServiceDb service = NewsServiceDb();
  late String user;
  static List<Map<String,dynamic>> myList = [];

  Future<void> init(String currentUser) async {
    user = currentUser;
   newsLocal = await service.retrieveData(user);
  }



  insertData(News news)async{
    service.insertData(news,user);
    newsLocal = await service.retrieveData(user);
    notifyListeners();
  }

  deleteData(News news) async{
    service.deleteData(news,user);
    newsLocal = await service.retrieveData(user);
    notifyListeners();
  }


}

