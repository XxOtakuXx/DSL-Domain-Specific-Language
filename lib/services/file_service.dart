import 'dart:io';
import 'package:file_picker/file_picker.dart';

/// Handles all file I/O: load DSL, save DSL, export JSON, export prompt.
class FileService {
  // ── Load ──────────────────────────────────────────────────────────────────

  /// Opens a file picker and returns the file contents as a String.
  /// Returns null if cancelled or file unreadable.
  Future<String?> loadDslFile() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Open DSL File',
      type: FileType.custom,
      allowedExtensions: ['dsl', 'txt'],
      allowMultiple: false,
    );
    if (result == null || result.files.single.path == null) return null;
    try {
      return await File(result.files.single.path!).readAsString();
    } catch (_) {
      return null;
    }
  }

  // ── Save DSL ──────────────────────────────────────────────────────────────

  Future<bool> saveDslFile(String content) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save DSL File',
      fileName: 'prompt.dsl',
      type: FileType.custom,
      allowedExtensions: ['dsl'],
    );
    if (path == null) return false;
    try {
      await File(path).writeAsString(content);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Export JSON ───────────────────────────────────────────────────────────

  Future<bool> exportJson(String jsonContent) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Export JSON',
      fileName: 'output.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (path == null) return false;
    try {
      await File(path).writeAsString(jsonContent);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Export Prompt ─────────────────────────────────────────────────────────

  Future<bool> exportPrompt(String promptContent) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Export Prompt',
      fileName: 'prompt.txt',
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );
    if (path == null) return false;
    try {
      await File(path).writeAsString(promptContent);
      return true;
    } catch (_) {
      return false;
    }
  }
}
