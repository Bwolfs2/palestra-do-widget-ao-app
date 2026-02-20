import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';
import '../widgets/code_viewer.dart';
import '../widgets/shared_widgets.dart';

class EfemeroScreen extends StatelessWidget {
  const EfemeroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.flash_on_rounded,
            color: AppTheme.secondary,
            title: 'Estado Efêmero',
            subtitle: 'Estado que vive dentro do widget, não compartilhado',
            tag: 'setState',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.secondary.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              'Estado efêmero é temporário e local ao widget. Pode ser descartado quando não for mais necessário. '
              'Exemplos: estado de checkbox, valor de campo de texto, tab selecionada.',
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const _TermsCheckboxDemo(),
          const SizedBox(height: 24),
          const _CounterDemo(),
          const SizedBox(height: 24),
          const _TextFieldDemo(),
        ],
      ),
    );
  }
}

// ─── Demo 1: TermsCheckbox (exatamente do slide 7) ──────────────────────────

class _TermsCheckboxDemo extends StatefulWidget {
  const _TermsCheckboxDemo();

  @override
  State<_TermsCheckboxDemo> createState() => _TermsCheckboxDemoState();
}

class _TermsCheckboxDemoState extends State<_TermsCheckboxDemo> {
  bool isChecked = false;

  static const _code = '''class TermsCheckbox extends StatefulWidget {
  const TermsCheckbox({super.key});
  @override
  State<TermsCheckbox> createState()
      => _TermsCheckboxState();
}

class _TermsCheckboxState
    extends State<TermsCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = value ?? false;
        });
      },
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return _DemoLayout(
      title: 'TermsCheckbox',
      subtitle: 'Exatamente como no Slide 7',
      code: _code,
      demo: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.codeBorder),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Aceito os termos de uso e política de privacidade',
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isChecked
                    ? AppTheme.tertiary.withValues(alpha: 0.15)
                    : AppTheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isChecked
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: isChecked ? AppTheme.tertiary : AppTheme.secondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isChecked ? 'isChecked = true' : 'isChecked = false',
                    style: GoogleFonts.firaCode(
                      color: isChecked ? AppTheme.tertiary : AppTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isChecked ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                disabledBackgroundColor: AppTheme.codeBorder,
              ),
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Demo 2: Counter ────────────────────────────────────────────────────────

class _CounterDemo extends StatefulWidget {
  const _CounterDemo();

  @override
  State<_CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<_CounterDemo> {
  int _count = 0;
  int _builds = 0;

  void _increment() => setState(() {
    _count++;
    _builds++;
  });
  void _decrement() => setState(() {
    _count--;
    _builds++;
  });
  void _reset() => setState(() {
    _count = 0;
    _builds++;
  });

  static const _code = '''class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  @override
  State<CounterWidget> createState()
      => _CounterWidgetState();
}

class _CounterWidgetState
    extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('\$_count'),
      ElevatedButton(
        onPressed: () => setState(() {
          _count++;
        }),
        child: Text('Incrementar'),
      ),
    ]);
  }
}''';

  @override
  Widget build(BuildContext context) {
    return _DemoLayout(
      title: 'Counter',
      subtitle: 'setState para atualizar um inteiro',
      code: _code,
      demo: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: _count),
              duration: const Duration(milliseconds: 300),
              builder: (context, val, _) => Text(
                '$val',
                style: GoogleFonts.inter(
                  color: AppTheme.textPrimary,
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'builds: $_builds',
              style: GoogleFonts.firaCode(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleButton(
                  Icons.remove_rounded,
                  AppTheme.secondary,
                  _decrement,
                ),
                const SizedBox(width: 12),
                _CircleButton(
                  Icons.refresh_rounded,
                  AppTheme.textSecondary,
                  _reset,
                ),
                const SizedBox(width: 12),
                _CircleButton(Icons.add_rounded, AppTheme.tertiary, _increment),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _CircleButton(this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}

// ─── Demo 3: TextEditingController ──────────────────────────────────────────

class _TextFieldDemo extends StatefulWidget {
  const _TextFieldDemo();

  @override
  State<_TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<_TextFieldDemo> {
  late final TextEditingController _ctrl;
  String _value = '';
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    _ctrl.addListener(() => setState(() => _value = _ctrl.text));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static const _code = '''class _State extends State<LoginForm> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose(); // IMPORTANTE!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Senha',
      ),
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return _DemoLayout(
      title: 'TextEditingController',
      subtitle: 'Controller como estado efêmero (dispose obrigatório)',
      code: _code,
      demo: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              obscureText: _obscure,
              style: GoogleFonts.inter(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Digite algo...',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: AppTheme.textSecondary,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_value.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '_ctrl.text: ',
                      style: GoogleFonts.firaCode(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '"$_value"',
                      style: GoogleFonts.firaCode(
                        color: AppTheme.accentLight,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_value.length} chars',
                      style: GoogleFonts.firaCode(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Layout helper ─────────────────────────────────────────────────────────

class _DemoLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final String code;
  final Widget demo;

  const _DemoLayout({
    required this.title,
    required this.subtitle,
    required this.code,
    required this.demo,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1000;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (isWide)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CodeViewer(code: code),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: demo,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(height: 320, child: CodeViewer(code: code)),
                ),
                const Divider(height: 1),
                Padding(padding: const EdgeInsets.all(16), child: demo),
              ],
            ),
        ],
      ),
    );
  }
}
