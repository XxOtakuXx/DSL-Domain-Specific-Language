import 'package:flutter_test/flutter_test.dart';
import 'package:dsl_domain_specific_language/services/parser.dart';
import 'package:dsl_domain_specific_language/services/prompt_builder.dart';

void main() {
  group('DslParser', () {
    final parser = DslParser();

    test('parses key-value pairs', () {
      final result = parser.parse('CREATE app\nTYPE web');
      expect(result['create'], 'app');
      expect(result['type'], 'web');
    });

    test('splits comma-separated values into lists', () {
      final result = parser.parse('FEATURES login, dashboard, payments');
      expect(result['features'], ['login', 'dashboard', 'payments']);
    });

    test('normalizes keys to lowercase', () {
      final result = parser.parse('Create APP');
      expect(result.containsKey('create'), true);
    });

    test('ignores blank lines and comments', () {
      final result = parser.parse('\n# comment\nCREATE app\n');
      expect(result.keys.length, 1);
    });

    test('ignores lines without a space', () {
      final result = parser.parse('BADLINE\nGOOD value');
      expect(result.containsKey('badline'), false);
      expect(result['good'], 'value');
    });
  });

  group('PromptBuilder', () {
    final builder = PromptBuilder();

    test('compact output contains TASK and FEATURES', () {
      final data = {
        'create': 'app',
        'type': 'web',
        'features': ['login', 'dashboard'],
      };
      final compact = builder.buildCompact(data);
      expect(compact, contains('TASK:'));
      expect(compact, contains('FEATURES:'));
    });

    test('compact compresses login to auth', () {
      final data = {'create': 'app', 'features': ['login']};
      final compact = builder.buildCompact(data);
      expect(compact, contains('auth'));
    });

    test('expanded output is a sentence', () {
      final data = {
        'create': 'app',
        'type': 'web',
        'style': 'modern dark',
        'features': ['dashboard', 'payments'],
        'output': 'full code',
      };
      final expanded = builder.buildExpanded(data);
      expect(expanded, contains('Build'));
      expect(expanded, contains('.'));
    });

    test('returns empty string for empty input', () {
      expect(builder.buildCompact({}), '');
      expect(builder.buildExpanded({}), '');
    });
  });
}
