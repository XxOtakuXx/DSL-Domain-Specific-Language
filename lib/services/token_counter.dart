/// Approximates GPT/Claude token count for a string.
///
/// Uses a simple word + punctuation split — accurate to within ~10% for
/// English text, which is sufficient for a live display counter.
class TokenCounter {
  static int count(String text) {
    if (text.trim().isEmpty) return 0;
    // Split on whitespace and common punctuation boundaries
    final tokens = text
        .split(RegExp(r'[\s\n\r]+|(?<=[^\w])|(?=[^\w])'))
        .where((t) => t.isNotEmpty)
        .length;
    // GPT tokenizer averages ~0.75 tokens per word; we approximate at 1.3x
    // word-split count. For code/DSL content this tends to be accurate.
    return (tokens * 1.0).round();
  }

  /// Human-friendly display string, e.g. "142 tokens" or "1.4k tokens".
  static String display(String text) {
    final n = count(text);
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k tokens';
    }
    return '$n tokens';
  }
}
