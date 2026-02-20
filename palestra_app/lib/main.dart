import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'app/theme_notifier.dart';
import 'app/router.dart';

void main() {
  runApp(const PalestraApp());
}

class PalestraApp extends StatelessWidget {
  const PalestraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, _) {
        return MaterialApp.router(
          title: 'Do Widget ao App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          routerConfig: router,
        );
      },
    );
  }
}
