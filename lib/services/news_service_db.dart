import 'package:sqflite/sqflite.dart';
import '../model/news.dart';
import 'package:path/path.dart';

class NewsServiceDb{
  //////////////////////////////////////////////////////////
  late String generalPath;
  String myDatabaseName="News_db.db";
  late String newsDatabase;
  String newsTable="MyNews";
  late Future<Database> database;
  static List<News>newsLocal=[];
  List<News> get getNewsLocal => newsLocal;
//////////////////////////////////////////////////////////

  static List<Map<String,dynamic>> myList = [];

  NewsServiceDb(){
    database = openMyDatabase();

  }

  Future<Database> openMyDatabase()async{
    generalPath=await getDatabasesPath();
    newsDatabase=join(generalPath,myDatabaseName);
    print("Creating table $newsTable");
    return openDatabase(newsDatabase,onCreate: (db,version){
      db.execute('CREATE TABLE $newsTable(user TEXT,title TEXT,author TEXT,description TEXT,urlToImage TEXT,url TEXT INTEGER)');
    },version: 1);
  }

  insertData(News news,String user)async{
    try{
      Database db=await database;
      db.insert(newsTable,
          {'user': user,'title': news.title,'author': news.author,'description':news.description,'urlToImage':news.urlToImage,'url':news.url},
          conflictAlgorithm: ConflictAlgorithm.ignore);
      retrieveData(user);
    }
    catch(e){
      print(e);
    }
  }

  deleteData(News news,String user) async{
    try{
      Database db = await database;
      await db.delete(
        newsTable,
        where: "user = ? AND title = ?",
        whereArgs: [user,news.title],
      );

      retrieveData(user);
    }
    catch(e){
      print(e);
    }

  }

  Future<List<News>> retrieveData(String user)async{

    Database db=await database;
    myList=await db.query(newsTable,
    where: 'user = ?',
    whereArgs: [user]
    );


    newsLocal.clear();
    for (var item in myList) {
      newsLocal.add(News.fromJson(item));
    }



    return newsLocal;

  }
}