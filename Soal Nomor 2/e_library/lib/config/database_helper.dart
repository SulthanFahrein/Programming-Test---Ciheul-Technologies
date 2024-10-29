import 'package:e_library/model/book_model.dart';
import 'package:e_library/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'library.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            photo_url TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            author TEXT NOT NULL,
            year INTEGER NOT NULL,
            cover_url TEXT,
            is_favorite BOOLEAN DEFAULT 0,
            user_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            book_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (book_id) REFERENCES books(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE search_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            keyword TEXT,
            created_at TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE uploads (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            book_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (book_id) REFERENCES books(id)
          )
        ''');
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert('books', book.toMap());
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> updateUserPhoto(int userId, String photoUrl) async {
  final db = await database;
  await db.update(
    'users',
    {'photo_url': photoUrl}, 
    where: 'id = ?',
    whereArgs: [userId],
  );
}

Future<void> insertFavorite(int userId, int bookId) async {
    final db = await database;
    await db.insert('favorites', {'user_id': userId, 'book_id': bookId});
  }

  Future<List<int>> getFavorites(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => maps[i]['book_id'] as int);
  }

  Future<void> deleteFavorite(int userId, int bookId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'user_id = ? AND book_id = ?',
      whereArgs: [userId, bookId],
    );
  }


}
