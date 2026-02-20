import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';
import '../widgets/code_viewer.dart';
import '../widgets/shared_widgets.dart';

class LifecycleScreen extends StatefulWidget {
  const LifecycleScreen({super.key});

  @override
  State<LifecycleScreen> createState() => _LifecycleScreenState();
}

class _LifecycleScreenState extends State<LifecycleScreen> {
  bool _widgetCreated = false;
  int _updateCount = 0;
  final List<_LogEntry> _log = [];
  final _scrollController = ScrollController();

  void _addLog(String method, Color color, String description) {
    setState(() {
      _log.add(
        _LogEntry(
          method: method,
          color: color,
          description: description,
          time: DateTime.now(),
        ),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _createWidget() {
    if (_widgetCreated) return;
    setState(() => _widgetCreated = true);
    _addLog('Constructor', const Color(0xFF8BE9FD), 'Widget instanciado');
    Future.delayed(const Duration(milliseconds: 200), () {
      _addLog(
        'initState()',
        AppTheme.tertiary,
        'Estado inicial configurado. Chamado uma vez.',
      );
      Future.delayed(const Duration(milliseconds: 200), () {
        _addLog(
          'didChangeDependencies()',
          AppTheme.accentLight,
          'Dependências disponíveis.',
        );
        Future.delayed(const Duration(milliseconds: 200), () {
          _addLog(
            'build()',
            const Color(0xFFFFB86C),
            'Widget renderizado na tela.',
          );
        });
      });
    });
  }

  void _updateWidget() {
    if (!_widgetCreated) return;
    setState(() => _updateCount++);
    _addLog('setState()', AppTheme.secondary, 'Estado marcado como dirty.');
    Future.delayed(const Duration(milliseconds: 200), () {
      _addLog(
        'build()',
        const Color(0xFFFFB86C),
        'Widget re-renderizado (rebuild #$_updateCount).',
      );
    });
  }

  void _changeDependency() {
    if (!_widgetCreated) return;
    _addLog(
      'didUpdateWidget()',
      const Color(0xFFFFA94D),
      'Widget pai reconstruído com novos parâmetros.',
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      _addLog(
        'build()',
        const Color(0xFFFFB86C),
        'Widget re-renderizado após atualização.',
      );
    });
  }

  void _disposeWidget() {
    if (!_widgetCreated) return;
    _addLog(
      'dispose()',
      AppTheme.secondary,
      'Recursos liberados. Widget removido da árvore.',
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _widgetCreated = false;
        _updateCount = 0;
      });
    });
  }

  void _clearLog() {
    setState(() => _log.clear());
  }

  static const _code = '''class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState()
      => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Chamado uma vez ao criar o State
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // InheritedWidget mudou
  }

  @override
  void didUpdateWidget(MyWidget old) {
    super.didUpdateWidget(old);
    // Widget pai reconstruiu com novos params
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Renderiza
  }

  @override
  void dispose() {
    // Libera recursos (controllers, streams)
    super.dispose();
  }
}''';

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.loop_rounded,
            color: AppTheme.tertiary,
            title: 'Widget Lifecycle',
            subtitle: 'Ciclo de vida do StatefulWidget',
            tag: 'lifecycle',
          ),
          const SizedBox(height: 28),
          if (isWide)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 520,
                      child: CodeViewer(code: _code),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 6,
                    child: _LifecycleDemo(
                      widgetCreated: _widgetCreated,
                      log: _log,
                      scrollController: _scrollController,
                      onCreate: _createWidget,
                      onUpdate: _updateWidget,
                      onChangeDep: _changeDependency,
                      onDispose: _disposeWidget,
                      onClear: _clearLog,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                SizedBox(height: 360, child: CodeViewer(code: _code)),
                const SizedBox(height: 24),
                _LifecycleDemo(
                  widgetCreated: _widgetCreated,
                  log: _log,
                  scrollController: _scrollController,
                  onCreate: _createWidget,
                  onUpdate: _updateWidget,
                  onChangeDep: _changeDependency,
                  onDispose: _disposeWidget,
                  onClear: _clearLog,
                ),
              ],
            ),
          const SizedBox(height: 28),
          _buildDiagram(),
        ],
      ),
    );
  }

  Widget _buildDiagram() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fluxo do Lifecycle',
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _DiagramNode('Created', const Color(0xFF8BE9FD)),
                _arrow(),
                _DiagramNode('initState', AppTheme.tertiary),
                _arrow(),
                _DiagramNode('didChangeDependencies', AppTheme.accentLight),
                _arrow(),
                _DiagramNode('build', const Color(0xFFFFB86C)),
                _DiagramBranch(
                  setState: 'setState / didUpdateWidget',
                  dispose: 'dispose',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: AppTheme.textSecondary,
        size: 18,
      ),
    );
  }
}

class _DiagramNode extends StatelessWidget {
  final String label;
  final Color color;
  const _DiagramNode(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: GoogleFonts.firaCode(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DiagramBranch extends StatelessWidget {
  final String setState;
  final String dispose;
  const _DiagramBranch({required this.setState, required this.dispose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.subdirectory_arrow_right_rounded,
                color: AppTheme.secondary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.secondary.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  setState,
                  style: GoogleFonts.firaCode(
                    color: AppTheme.secondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.subdirectory_arrow_right_rounded,
                color: Color(0xFFFFA94D),
                size: 16,
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA94D).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFFA94D).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  dispose,
                  style: GoogleFonts.firaCode(
                    color: const Color(0xFFFFA94D),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LifecycleDemo extends StatelessWidget {
  final bool widgetCreated;
  final List<_LogEntry> log;
  final ScrollController scrollController;
  final VoidCallback onCreate;
  final VoidCallback onUpdate;
  final VoidCallback onChangeDep;
  final VoidCallback onDispose;
  final VoidCallback onClear;

  const _LifecycleDemo({
    required this.widgetCreated,
    required this.log,
    required this.scrollController,
    required this.onCreate,
    required this.onUpdate,
    required this.onChangeDep,
    required this.onDispose,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Text(
                  'Demo Interativo',
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widgetCreated
                        ? AppTheme.tertiary
                        : AppTheme.textSecondary,
                    boxShadow: widgetCreated
                        ? [
                            BoxShadow(
                              color: AppTheme.tertiary.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widgetCreated ? 'Widget ativo' : 'Sem widget',
                  style: GoogleFonts.inter(
                    color: widgetCreated
                        ? AppTheme.tertiary
                        : AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionButton(
                  'Criar Widget',
                  Icons.add_circle_outline_rounded,
                  AppTheme.tertiary,
                  onPressed: widgetCreated ? null : onCreate,
                ),
                _ActionButton(
                  'setState()',
                  Icons.refresh_rounded,
                  AppTheme.secondary,
                  onPressed: widgetCreated ? onUpdate : null,
                ),
                _ActionButton(
                  'didUpdateWidget',
                  Icons.swap_horiz_rounded,
                  const Color(0xFFFFA94D),
                  onPressed: widgetCreated ? onChangeDep : null,
                ),
                _ActionButton(
                  'Dispose',
                  Icons.delete_outline_rounded,
                  const Color(0xFFFF6B9D),
                  onPressed: widgetCreated ? onDispose : null,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: Row(
              children: [
                Icon(
                  Icons.terminal_rounded,
                  size: 14,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Console',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onClear,
                  child: Text(
                    'Limpar',
                    style: GoogleFonts.inter(
                      color: AppTheme.accent,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 280,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.codeBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.codeBorder),
            ),
            child: log.isEmpty
                ? Center(
                    child: Text(
                      'Clique em "Criar Widget" para começar',
                      style: GoogleFonts.firaCode(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: log.length,
                    itemBuilder: (context, i) => _LogLine(entry: log[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton(this.label, this.icon, this.color, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.4,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.15),
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          textStyle: GoogleFonts.firaCode(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}

class _LogLine extends StatelessWidget {
  final _LogEntry entry;
  const _LogLine({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _time(entry.time),
            style: GoogleFonts.firaCode(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: entry.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              entry.method,
              style: GoogleFonts.firaCode(
                color: entry.color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              entry.description,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _time(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';
}

class _LogEntry {
  final String method;
  final Color color;
  final String description;
  final DateTime time;

  _LogEntry({
    required this.method,
    required this.color,
    required this.description,
    required this.time,
  });
}
