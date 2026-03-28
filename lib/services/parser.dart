/// Parses multiline DSL input into a structured Map.
///
/// Rules:
///   • One instruction per line — `KEY VALUE`
///   • Keys are case-insensitive and trimmed
///   • Lines starting with `#` are treated as comments and skipped
///   • Blank lines are skipped
///   • Values containing commas are split into a list of strings
///   • Invalid / malformed lines are silently ignored
class DslParser {
  Map<String, dynamic> parse(String input) {
    final result = <String, dynamic>{};

    for (final rawLine in input.split('\n')) {
      final line = rawLine.trim();

      // skip blank lines and comments
      if (line.isEmpty || line.startsWith('#')) continue;

      final spaceIdx = line.indexOf(' ');
      if (spaceIdx == -1) continue; // no value — skip

      final key = line.substring(0, spaceIdx).toLowerCase().trim();
      final value = line.substring(spaceIdx + 1).trim();

      if (key.isEmpty || value.isEmpty) continue;

      if (value.contains(',')) {
        result[key] = value
            .split(',')
            .map((v) => v.trim())
            .where((v) => v.isNotEmpty)
            .toList();
      } else {
        result[key] = value;
      }
    }

    return result;
  }
}
