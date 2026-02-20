import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';
import '../widgets/shared_widgets.dart';

class ValueNotifierScreen extends StatelessWidget {
  const ValueNotifierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.notifications_active_rounded,
            color: Color(0xFFFFA94D),
            title: 'ValueNotifier',
            subtitle: 'Notifique widgets sem setState no pai',
            tag: 'notifier',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFA94D).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFA94D).withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              'ValueNotifier e ChangeNotifier permitem que widgets sejam reconstruídos de forma seletiva '
              'sem chamar setState no widget pai. Ótimo para estado local mais complexo.',
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const _ValueNotifierDemo(),
          const SizedBox(height: 24),
          const _ChangeNotifierDemo(),
        ],
      ),
    );
  }
}

// ─── Demo 1: ValueNotifier ──────────────────────────────────────────────────

class _ValueNotifierDemo extends StatefulWidget {
  const _ValueNotifierDemo();

  @override
  State<_ValueNotifierDemo> createState() => _ValueNotifierDemoState();
}

class _ValueNotifierDemoState extends State<_ValueNotifierDemo> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  int _listenerCallCount = 0;

  @override
  void initState() {
    super.initState();
    _counter.addListener(() {
      if (mounted) setState(() => _listenerCallCount++);
    });
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  static const _code = '''// Criar o notifier
final counter = ValueNotifier<int>(0);

// Usar no widget
ValueListenableBuilder<int>(
  valueListenable: counter,
  builder: (context, value, _) {
    // Só isso reconstrói, não o widget pai!
    return Text('\$value');
  },
);

// Atualizar (sem setState!)
counter.value++;

// Lembrar de liberar
@override
void dispose() {
  counter.dispose();
  super.dispose();
}''';

  @override
  Widget build(BuildContext context) {
    return DemoLayout(
      title: 'ValueNotifier<int>',
      subtitle: 'Rebuild seletivo com ValueListenableBuilder',
      code: _code,
      demo: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA94D).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFFA94D).withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                'Widget pai NÃO reconstrói → apenas o ValueListenableBuilder',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFFA94D),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (context, value, _) {
                return Column(
                  children: [
                    Text(
                      '$value',
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'counter.value = $value',
                      style: GoogleFonts.firaCode(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleButton(
                  Icons.remove_rounded,
                  AppTheme.secondary,
                  () => _counter.value--,
                ),
                const SizedBox(width: 12),
                CircleButton(
                  Icons.refresh_rounded,
                  AppTheme.textSecondary,
                  () => _counter.value = 0,
                ),
                const SizedBox(width: 12),
                CircleButton(
                  Icons.add_rounded,
                  AppTheme.tertiary,
                  () => _counter.value++,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Total de notificações: $_listenerCallCount',
              style: GoogleFonts.firaCode(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Demo 2: ChangeNotifier ─────────────────────────────────────────────────

class _TodoNotifier extends ChangeNotifier {
  final List<String> _items = [];
  List<String> get items => List.unmodifiable(_items);

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}

class _ChangeNotifierDemo extends StatefulWidget {
  const _ChangeNotifierDemo();

  @override
  State<_ChangeNotifierDemo> createState() => _ChangeNotifierDemoState();
}

class _ChangeNotifierDemoState extends State<_ChangeNotifierDemo> {
  final _notifier = _TodoNotifier();
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _notifier.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  static const _code = '''class TodoNotifier extends ChangeNotifier {
  final List<String> _items = [];
  List<String> get items
      => List.unmodifiable(_items);

  void add(String item) {
    _items.add(item);
    notifyListeners(); // notifica listeners
  }

  void remove(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}

// No widget:
final notifier = TodoNotifier();

ListenableBuilder(
  listenable: notifier,
  builder: (context, _) {
    return ListView(
      children: notifier.items
        .map((item) => Text(item))
        .toList(),
    );
  },
);''';

  @override
  Widget build(BuildContext context) {
    return DemoLayout(
      title: 'ChangeNotifier',
      subtitle: 'notifyListeners() para listas e objetos complexos',
      code: _code,
      demo: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Adicionar item...',
                      hintStyle: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (v) {
                      if (v.trim().isNotEmpty) {
                        _notifier.add(v.trim());
                        _ctrl.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_ctrl.text.trim().isNotEmpty) {
                      _notifier.add(_ctrl.text.trim());
                      _ctrl.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA94D),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Icon(Icons.add_rounded, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: _notifier,
              builder: (context, _) {
                if (_notifier.items.isEmpty) {
                  return Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Text(
                      'Lista vazia. Adicione itens!',
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  );
                }
                return Column(
                  children: _notifier.items.asMap().entries.map((entry) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.codeBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 6,
                            color: Color(0xFFFFA94D),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: GoogleFonts.inter(
                                color: AppTheme.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _notifier.remove(entry.key),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
