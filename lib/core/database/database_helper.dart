import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract final class DatabaseHelper {
  static Database? _instance;

  static Future<Database> get database async {
    if (_instance != null) return _instance!;
    _instance = await _init();
    return _instance!;
  }

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'feed.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        subtitle TEXT NOT NULL,
        text TEXT NOT NULL,
        imageUrl TEXT NOT NULL DEFAULT '',
        likesCount INTEGER NOT NULL DEFAULT 0,
        isLiked INTEGER NOT NULL DEFAULT 0,
        commentsCount INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postId INTEGER NOT NULL,
        username TEXT NOT NULL,
        text TEXT NOT NULL,
        avatarUrl TEXT NOT NULL DEFAULT '',
        createdAt TEXT NOT NULL,
        FOREIGN KEY (postId) REFERENCES posts (id) ON DELETE CASCADE
      )
    ''');
  }
}
