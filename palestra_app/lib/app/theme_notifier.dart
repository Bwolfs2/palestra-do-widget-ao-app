import 'package:flutter/material.dart';

/// Global notifier for theme mode – use ThemeNotifier.instance
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier._() : super(ThemeMode.dark);
  static final instance = ThemeNotifier._();

  bool get isDark => value == ThemeMode.dark;

  void toggle() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}
