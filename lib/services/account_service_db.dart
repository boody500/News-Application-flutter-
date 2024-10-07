import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            firstname TEXT NOT NULL,
            lastname TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertUser(String email, String password,String firstname,String lastname) async {
    final db = await database;
    await db.insert(
      'user',
      {'email': email, 'password': password,'firstname':firstname,'lastname':lastname},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<Map<String, String>?> getUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return {
        'email': maps.first['email'] as String,
        'password': maps.first['password'] as String,
      };
    }
    return null; // Return null if no user found
  }

  Future<Map<String, dynamic>> getUserInfo(String email) async {
    final db = await database;

    // Query the user table for the specified email
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      columns: ['firstname', 'lastname'], // Only retrieve firstName and lastName
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      // Return a map containing firstName and lastName
      return {
        'firstname': maps[0]['firstname'],
        'lastname': maps[0]['lastname'],
      };
    } else {
      throw Exception('User not found');
    }
  }

}
