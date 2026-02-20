import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';

/// Displays a syntax-highlighted (ish) code block with a nice dark background
class CodeViewer extends StatelessWidget {
  final String code;
  final String? language;

  const CodeViewer({super.key, required this.code, this.language = 'dart'});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.codeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // window chrome bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.codeBorder)),
            ),
            child: Row(
              children: [
                _dot(const Color(0xFFFF6059)),
                const SizedBox(width: 6),
                _dot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF28C840)),
                const Spacer(),
                if (language != null)
                  Text(
                    language!,
                    style: GoogleFonts.firaCode(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _highlightCode(code),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _highlightCode(String code) {
    // Simple token-based highlighting for Dart
    final lines = code.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => _buildLine(line)).toList(),
    );
  }

  Widget _buildLine(String line) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text.rich(_tokenize(line)),
    );
  }

  TextSpan _tokenize(String line) {
    final spans = <TextSpan>[];
    const keywords = [
      'class',
      'extends',
      'implements',
      'with',
      'mixin',
      'abstract',
      'final',
      'const',
      'late',
      'var',
      'void',
      'bool',
      'int',
      'double',
      'String',
      'List',
      'Map',
      'Set',
      'dynamic',
      'Object',
      'Widget',
      'State',
      'BuildContext',
      'override',
      'return',
      'if',
      'else',
      'true',
      'false',
      'null',
      'super',
      'this',
      'new',
      'import',
      'async',
      'await',
      'Future',
      'Stream',
      'required',
      'get',
      'set',
    ];
    const baseStyle = TextStyle(
      fontFamily: 'FiraCode',
      fontSize: 13,
      height: 1.6,
      color: Color(0xFFCDD6F4),
    );

    // Trim the line but detect leading spaces first
    final leadingSpaces = line.length - line.trimLeft().length;
    final trimmed = line.trim();

    // comments
    if (trimmed.startsWith('//')) {
      return TextSpan(
        text: line,
        style: baseStyle.copyWith(color: const Color(0xFF6272A4)),
      );
    }

    if (leadingSpaces > 0) {
      spans.add(TextSpan(text: ' ' * leadingSpaces, style: baseStyle));
    }

    // Very simple word tokenizer
    final pattern = RegExp(r"""([a-zA-Z_]\w*|'[^']*'|"[^"]*"|\d+|[^\w\s])""");
    final matches = pattern.allMatches(trimmed);
    int lastEnd = 0;

    for (final m in matches) {
      if (m.start > lastEnd) {
        spans.add(
          TextSpan(text: trimmed.substring(lastEnd, m.start), style: baseStyle),
        );
      }
      final word = m.group(0)!;
      Color color;
      if (keywords.contains(word)) {
        color = const Color(0xFFBD93F9); // purple
      } else if (word.startsWith("'") || word.startsWith('"')) {
        color = const Color(0xFFF1FA8C); // yellow strings
      } else if (RegExp(r'^\d+$').hasMatch(word)) {
        color = const Color(0xFFFFB86C); // orange numbers
      } else if (word == '(' ||
          word == ')' ||
          word == '{' ||
          word == '}' ||
          word == '[' ||
          word == ']') {
        color = const Color(0xFFF8F8F2); // white brackets
      } else if (RegExp(r'^[A-Z]').hasMatch(word)) {
        color = const Color(0xFF8BE9FD); // cyan types
      } else {
        color = const Color(0xFFCDD6F4); // default
      }
      spans.add(
        TextSpan(
          text: word,
          style: baseStyle.copyWith(color: color),
        ),
      );
      lastEnd = m.end;
    }
    if (lastEnd < trimmed.length) {
      spans.add(TextSpan(text: trimmed.substring(lastEnd), style: baseStyle));
    }

    return TextSpan(children: spans);
  }
}
