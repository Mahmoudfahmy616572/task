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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        parentId INTEGER,
        username TEXT NOT NULL,
        text TEXT NOT NULL,
        avatarUrl TEXT NOT NULL DEFAULT '',
        createdAt TEXT NOT NULL,
        likesCount INTEGER NOT NULL DEFAULT 0,
        dislikesCount INTEGER NOT NULL DEFAULT 0,
        isLiked INTEGER NOT NULL DEFAULT 0,
        isDisliked INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (postId) REFERENCES posts (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE comments ADD COLUMN parentId INTEGER');
      await db.execute('ALTER TABLE comments ADD COLUMN likesCount INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE comments ADD COLUMN dislikesCount INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE comments ADD COLUMN isLiked INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE comments ADD COLUMN isDisliked INTEGER NOT NULL DEFAULT 0');
    }
  }
}
