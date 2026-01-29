import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';
import '../models/category_model.dart';

class LocalStorageService {
  static final LocalStorageService instance = LocalStorageService._init();
  static Database? _database;

  LocalStorageService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER';

    // جدول الملاحظات
    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        title $textType,
        content $textType,
        createdDate $textType,
        categoryId $intType,
        isFavorite $intType DEFAULT 0
      )
    ''');

    // جدول المجموعات
    await db.execute('''
      CREATE TABLE categories (
        id $idType,
        name $textType,
        icon $textType,
        color $textType,
        createdDate $textType,
        translationKey TEXT
      )
    ''');


    await _insertDefaultCategories(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {

      await db.execute('ALTER TABLE notes ADD COLUMN categoryId INTEGER');
      await db.execute('ALTER TABLE notes ADD COLUMN isFavorite INTEGER DEFAULT 0');


      await db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          icon TEXT NOT NULL,
          color TEXT NOT NULL,
          createdDate TEXT NOT NULL,
          translationKey TEXT
        )
      ''');

      await _insertDefaultCategories(db);
    }

    if (oldVersion < 3) {

      try {
        await db.execute('ALTER TABLE categories ADD COLUMN translationKey TEXT');
      } catch (e) {

      }


      await db.update(
        'categories',
        {'translationKey': 'category_work'},
        where: 'name = ? OR name = ?',
        whereArgs: ['Work', 'عمل'],
      );

      await db.update(
        'categories',
        {'translationKey': 'category_study'},
        where: 'name = ? OR name = ?',
        whereArgs: ['Study', 'دراسة'],
      );

      await db.update(
        'categories',
        {'translationKey': 'category_personal'},
        where: 'name = ? OR name = ?',
        whereArgs: ['Personal', 'شخصي'],
      );

      await db.update(
        'categories',
        {'translationKey': 'category_ideas'},
        where: 'name = ? OR name = ?',
        whereArgs: ['Ideas', 'أفكار'],
      );
    }
  }

  Future _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {
        'name': 'Work',
        'icon': 'work',
        'color': '0xFF2196F3',
        'createdDate': DateTime.now().toIso8601String(),
        'translationKey': 'category_work',
      },
      {
        'name': 'Study',
        'icon': 'school',
        'color': '0xFF4CAF50',
        'createdDate': DateTime.now().toIso8601String(),
        'translationKey': 'category_study',
      },
      {
        'name': 'Personal',
        'icon': 'person',
        'color': '0xFF9C27B0',
        'createdDate': DateTime.now().toIso8601String(),
        'translationKey': 'category_personal',
      },
      {
        'name': 'Ideas',
        'icon': 'lightbulb',
        'color': '0xFFFF9800',
        'createdDate': DateTime.now().toIso8601String(),
        'translationKey': 'category_ideas',
      },
    ];

    for (var category in defaultCategories) {
      await db.insert('categories', category);
    }
  }

  // ==================== ملاحظات ====================

  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    const orderBy = 'createdDate DESC';
    final result = await db.query('notes', orderBy: orderBy);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<List<Note>> getFavoriteNotes() async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'createdDate DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<List<Note>> getNotesByCategory(int categoryId) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'createdDate DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<Note?> getNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> toggleFavorite(int noteId, bool isFavorite) async {
    final db = await instance.database;
    return db.update(
      'notes',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdDate DESC',
    );
    return result.map((json) => Note.fromMap(json)).toList();
  }

  // ==================== مجموعات ====================

  Future<Category> createCategory(Category category) async {
    final db = await instance.database;
    final id = await db.insert('categories', category.toMap());
    return category.copyWith(id: id);
  }

  Future<List<Category>> getAllCategories() async {
    final db = await instance.database;
    const orderBy = 'createdDate ASC';
    final result = await db.query('categories', orderBy: orderBy);
    return result.map((json) => Category.fromMap(json)).toList();
  }

  Future<Category?> getCategory(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateCategory(Category category) async {
    final db = await instance.database;
    return db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await instance.database;

    await db.update(
      'notes',
      {'categoryId': null},
      where: 'categoryId = ?',
      whereArgs: [id],
    );

    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getNotesCountInCategory(int categoryId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM notes WHERE categoryId = ?',
      [categoryId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}