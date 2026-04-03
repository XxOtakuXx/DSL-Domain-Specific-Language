import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class CustomTemplate {
  const CustomTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.dsl,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final String dsl;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'category': category,
        'tags': tags.join(','),
        'dsl': dsl,
        'created_at': createdAt.toIso8601String(),
      };

  factory CustomTemplate.fromMap(Map<String, dynamic> m) => CustomTemplate(
        id: m['id'] as int,
        title: m['title'] as String,
        description: m['description'] as String,
        category: m['category'] as String,
        tags: (m['tags'] as String)
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList(),
        dsl: m['dsl'] as String,
        createdAt: DateTime.parse(m['created_at'] as String),
      );
}

// ── Service ───────────────────────────────────────────────────────────────────

class CustomTemplateService {
  static final CustomTemplateService _instance =
      CustomTemplateService._internal();
  factory CustomTemplateService() => _instance;
  CustomTemplateService._internal();

  Database? _db;

  Future<Database> get _database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final appDir = await getApplicationSupportDirectory();
    final dbPath = p.join(appDir.path, 'dsl_studio.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
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
      },
      onOpen: (db) async {
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
      },
    );
  }

  Future<int> insert(CustomTemplate t) async {
    final db = await _database;
    return db.insert('custom_templates', t.toMap());
  }

  Future<List<CustomTemplate>> loadAll() async {
    final db = await _database;
    final rows =
        await db.query('custom_templates', orderBy: 'created_at DESC');
    return rows.map(CustomTemplate.fromMap).toList();
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('custom_templates', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(CustomTemplate t) async {
    final db = await _database;
    await db.update('custom_templates', t.toMap(),
        where: 'id = ?', whereArgs: [t.id]);
  }
}
