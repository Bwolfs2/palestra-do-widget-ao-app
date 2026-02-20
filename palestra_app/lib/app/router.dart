import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/lifecycle_screen.dart';
import '../screens/efemero_screen.dart';
import '../screens/value_notifier_screen.dart';
import '../screens/provider_screen.dart';
import '../screens/bloc_screen.dart';
import '../widgets/app_shell.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/lifecycle',
          builder: (context, state) => const LifecycleScreen(),
        ),
        GoRoute(
          path: '/efemero',
          builder: (context, state) => const EfemeroScreen(),
        ),
        GoRoute(
          path: '/value-notifier',
          builder: (context, state) => const ValueNotifierScreen(),
        ),
        GoRoute(
          path: '/provider',
          builder: (context, state) => const ProviderScreen(),
        ),
        GoRoute(path: '/bloc', builder: (context, state) => const BlocScreen()),
      ],
    ),
  ],
);
