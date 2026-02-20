import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';
import '../app/theme_notifier.dart';

class NavItem {
  final String label;
  final String route;
  final IconData icon;
  final Color badgeColor;
  final String badge;

  const NavItem({
    required this.label,
    required this.route,
    required this.icon,
    required this.badgeColor,
    required this.badge,
  });
}

const _navItems = [
  NavItem(
    label: 'Início',
    route: '/',
    icon: Icons.home_rounded,
    badgeColor: AppTheme.accent,
    badge: '',
  ),
  NavItem(
    label: 'Widget Lifecycle',
    route: '/lifecycle',
    icon: Icons.loop_rounded,
    badgeColor: AppTheme.tertiary,
    badge: 'lifecycle',
  ),
  NavItem(
    label: 'Estado Efêmero',
    route: '/efemero',
    icon: Icons.flash_on_rounded,
    badgeColor: AppTheme.secondary,
    badge: 'setState',
  ),
  NavItem(
    label: 'ValueNotifier',
    route: '/value-notifier',
    icon: Icons.notifications_active_rounded,
    badgeColor: Color(0xFFFFA94D),
    badge: 'notifier',
  ),
  NavItem(
    label: 'Provider',
    route: '/provider',
    icon: Icons.share_rounded,
    badgeColor: Color(0xFF4ECDC4),
    badge: 'app state',
  ),
  NavItem(
    label: 'BLoC',
    route: '/bloc',
    icon: Icons.account_tree_rounded,
    badgeColor: Color(0xFFFF6B9D),
    badge: 'app state',
  ),
];

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      body: Row(
        children: [
          if (isWide) _Sidebar(currentLocation: location),
          Expanded(
            child: Column(
              children: [
                if (!isWide) _TopBar(currentLocation: location),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final String currentLocation;
  const _Sidebar({required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppTheme.surf(context),
        border: Border(right: BorderSide(color: AppTheme.border(context))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.accent, AppTheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.flutter_dash,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Do Widget',
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'ao App',
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'TÓPICOS',
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: _navItems
                  .map(
                    (item) =>
                        _NavTile(item: item, currentLocation: currentLocation),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: _ThemeToggle(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Text(
              'Vilson Dauinheimer\n[ Bwolf ]',
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
}

class _NavTile extends StatelessWidget {
  final NavItem item;
  final String currentLocation;
  const _NavTile({required this.item, required this.currentLocation});

  bool get isSelected {
    if (item.route == '/') return currentLocation == '/';
    return currentLocation.startsWith(item.route);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => context.go(item.route),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.accent.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppTheme.accent.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: isSelected
                      ? AppTheme.accentLight
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.inter(
                      color: isSelected
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (item.badge.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: item.badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: item.badgeColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      item.badge,
                      style: GoogleFonts.firaCode(
                        color: item.badgeColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String currentLocation;
  const _TopBar({required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.surf(context),
        border: Border(bottom: BorderSide(color: AppTheme.border(context))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: _navItems
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _NavChip(item: item, currentLocation: currentLocation),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  final NavItem item;
  final String currentLocation;
  const _NavChip({required this.item, required this.currentLocation});

  bool get isSelected {
    if (item.route == '/') return currentLocation == '/';
    return currentLocation.startsWith(item.route);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(item.route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accent.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.codeBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 14,
              color: isSelected ? AppTheme.accentLight : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: GoogleFonts.inter(
                color: isSelected
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final fg = isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
        final bg = isDark ? AppTheme.surfaceVariant : AppTheme.lightSurfaceVariant;
        final bd = isDark ? AppTheme.codeBorder : AppTheme.lightCodeBorder;
        return GestureDetector(
          onTap: ThemeNotifier.instance.toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: bd)),
            child: Row(children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    key: ValueKey(isDark), size: 16, color: isDark ? AppTheme.accentLight : AppTheme.accent),
              ),
              const SizedBox(width: 8),
              Text(isDark ? 'Tema Dark' : 'Tema Light',
                  style: GoogleFonts.inter(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32, height: 18, padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(color: isDark ? AppTheme.accent : AppTheme.lightCodeBorder, borderRadius: BorderRadius.circular(9)),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
