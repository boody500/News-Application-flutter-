import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CacheHelper {
  static final CacheHelper _instance = CacheHelper._internal();
  factory CacheHelper() => _instance;

  static Database? _database;
  static List<Map<String,dynamic>> myList = [];

  CacheHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cache_user.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE currentUser (
            email TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUser(String email) async {
    final db = await database;
    await db.insert(
      'currentUser',
      {'email': email},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<Map<String, String>> getCurrentUser() async {
    final db = await database;
    myList = await db.query('currentUser');

    if (myList.isNotEmpty) {

      return {
        'email': myList.first['email'] as String,
      };
    }
    return {
      'email': "empty",
    };
  }



  Future<void> deleteUser(String email) async {
    final db = await database;
    await db.delete('currentUser');
  }
}
