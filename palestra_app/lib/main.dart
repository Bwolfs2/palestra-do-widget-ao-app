import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'app/router.dart';

void main() {
  runApp(const PalestraApp());
}

class PalestraApp extends StatelessWidget {
  const PalestraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Do Widget ao App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
