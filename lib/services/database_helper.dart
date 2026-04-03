import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Single shared SQLite database instance for the entire app.
/// Both HistoryService and CustomTemplateService use this.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final appDir = await getApplicationSupportDirectory();
    final dbPath = p.join(appDir.path, 'dsl_studio.db');
    return openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT NOT NULL,
            input_mode TEXT NOT NULL,
            dsl_input TEXT NOT NULL,
            compact_prompt TEXT NOT NULL,
            expanded_prompt TEXT NOT NULL,
            json_data TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE custom_templates (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            category TEXT NOT NULL,
            tags TEXT NOT NULL,
            dsl TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS custom_templates (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              category TEXT NOT NULL,
              tags TEXT NOT NULL,
              dsl TEXT NOT NULL,
              created_at TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }
}
