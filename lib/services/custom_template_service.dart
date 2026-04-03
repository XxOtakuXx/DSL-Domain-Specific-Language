import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

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

  Future<Database> get _database => DatabaseHelper().database;

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
