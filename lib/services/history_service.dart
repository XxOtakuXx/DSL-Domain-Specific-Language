import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.timestamp,
    required this.inputMode,
    required this.dslInput,
    required this.compactPrompt,
    required this.expandedPrompt,
    required this.json,
  });

  final int id;
  final DateTime timestamp;
  final String inputMode; // 'dsl' | 'plainTalk'
  final String dslInput;
  final String compactPrompt;
  final String expandedPrompt;
  final Map<String, dynamic> json;

  Map<String, dynamic> toMap() => {
        'timestamp': timestamp.toIso8601String(),
        'input_mode': inputMode,
        'dsl_input': dslInput,
        'compact_prompt': compactPrompt,
        'expanded_prompt': expandedPrompt,
        'json_data': jsonEncode(json),
      };

  factory HistoryEntry.fromMap(Map<String, dynamic> m) => HistoryEntry(
        id: m['id'] as int,
        timestamp: DateTime.parse(m['timestamp'] as String),
        inputMode: m['input_mode'] as String,
        dslInput: m['dsl_input'] as String,
        compactPrompt: m['compact_prompt'] as String,
        expandedPrompt: m['expanded_prompt'] as String,
        json: jsonDecode(m['json_data'] as String) as Map<String, dynamic>,
      );

  /// First non-empty line of the DSL input, used as a display title.
  String get title {
    final first = dslInput
        .split('\n')
        .map((l) => l.trim())
        .firstWhere((l) => l.isNotEmpty && !l.startsWith('#'),
            orElse: () => '');
    return first.isEmpty ? 'Untitled' : first;
  }

  /// Short preview of compact prompt (first 80 chars).
  String get preview {
    final s = compactPrompt.replaceAll('\n', ' ');
    return s.length > 80 ? '${s.substring(0, 80)}…' : s;
  }
}

// ── Service ───────────────────────────────────────────────────────────────────

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  Future<Database> get _database => DatabaseHelper().database;

  /// Insert a new history entry. Keeps only the latest 100 entries.
  Future<void> insert(HistoryEntry entry) async {
    final db = await _database;
    await db.insert('history', entry.toMap());
    // Trim to 100 most recent
    await db.rawDelete('''
      DELETE FROM history WHERE id NOT IN (
        SELECT id FROM history ORDER BY id DESC LIMIT 100
      )
    ''');
  }

  /// Load all history entries, newest first.
  Future<List<HistoryEntry>> loadAll() async {
    final db = await _database;
    final rows = await db.query('history', orderBy: 'id DESC');
    return rows.map(HistoryEntry.fromMap).toList();
  }

  /// Delete a single entry by id.
  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  /// Delete all history.
  Future<void> clearAll() async {
    final db = await _database;
    await db.delete('history');
  }
}
