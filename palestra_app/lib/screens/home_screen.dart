import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _titleCtrl;
  late AnimationController _cardsCtrl;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _cardsFade;

  @override
  void initState() {
    super.initState();
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _titleFade = CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut);
    _titleSlide = Tween(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut));
    _cardsFade = CurvedAnimation(parent: _cardsCtrl, curve: Curves.easeOut);

    _titleCtrl.forward().then((_) => _cardsCtrl.forward());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _cardsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _titleFade,
            child: SlideTransition(
              position: _titleSlide,
              child: _buildHero(context),
            ),
          ),
          const SizedBox(height: 48),
          FadeTransition(opacity: _cardsFade, child: _buildTopicGrid(context)),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A3E), Color(0xFF0D0D1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.codeBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    'Flutter Palestra',
                    style: GoogleFonts.firaCode(
                      color: AppTheme.accentLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Do Widget\nao App',
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Entenda estado no Flutter: de setState a BLoC.\nExemplos interativos, código ao vivo.',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: () => context.go('/lifecycle'),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Começar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          _buildFlutterLogo(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [AppTheme.accent.withValues(alpha: 0.3), Colors.transparent],
        ),
      ),
      child: const Center(
        child: Icon(Icons.flutter_dash, size: 100, color: AppTheme.accent),
      ),
    );
  }

  Widget _buildTopicGrid(BuildContext context) {
    final topics = [
      _TopicCard(
        icon: Icons.loop_rounded,
        title: 'Widget Lifecycle',
        description:
            'Entenda o ciclo de vida do StatefulWidget: initState, build, dispose e mais.',
        color: AppTheme.tertiary,
        route: '/lifecycle',
        tag: 'lifecycle',
      ),
      _TopicCard(
        icon: Icons.flash_on_rounded,
        title: 'Estado Efêmero',
        description:
            'setState em ação. O estado que vive dentro do widget e não é compartilhado.',
        color: AppTheme.secondary,
        route: '/efemero',
        tag: 'setState',
      ),
      _TopicCard(
        icon: Icons.notifications_active_rounded,
        title: 'ValueNotifier',
        description:
            'Notifique widgets sobre mudanças com ValueNotifier e ChangeNotifier.',
        color: const Color(0xFFFFA94D),
        route: '/value-notifier',
        tag: 'notifier',
      ),
      _TopicCard(
        icon: Icons.share_rounded,
        title: 'Provider',
        description:
            'Estado de aplicação compartilhado entre widgets com Provider.',
        color: const Color(0xFF4ECDC4),
        route: '/provider',
        tag: 'app state',
      ),
      _TopicCard(
        icon: Icons.account_tree_rounded,
        title: 'BLoC',
        description:
            'Arquitetura com eventos e estados explícitos usando flutter_bloc.',
        color: const Color(0xFFFF6B9D),
        route: '/bloc',
        tag: 'app state',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tópicos',
          style: GoogleFonts.inter(
            color: AppTheme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: topics
              .map((t) => _buildTopicCardWidget(context, t))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTopicCardWidget(BuildContext context, _TopicCard t) {
    return SizedBox(
      width: 280,
      child: _HoverCard(
        onTap: () => context.go(t.route),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.codeBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: t.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(t.icon, color: t.color, size: 22),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: t.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: t.color.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      t.tag,
                      style: GoogleFonts.firaCode(
                        color: t.color,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                t.title,
                style: GoogleFonts.inter(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.description,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Ver exemplo',
                    style: GoogleFonts.inter(
                      color: t.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: t.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicCard {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final String route;
  final String tag;
  const _TopicCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.route,
    required this.tag,
  });
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _HoverCard({required this.child, required this.onTap});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovering ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              boxShadow: _hovering
                  ? [
                      BoxShadow(
                        color: AppTheme.accent.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
              borderRadius: BorderRadius.circular(16),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
