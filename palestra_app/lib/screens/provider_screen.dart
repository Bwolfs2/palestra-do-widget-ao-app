import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app/theme.dart';
import '../widgets/code_viewer.dart';
import '../widgets/shared_widgets.dart';

// ─── Model & Provider ───────────────────────────────────────────────────────

class Movie {
  final String title;
  final String genre;
  final String year;
  final Color color;
  const Movie(this.title, this.genre, this.year, this.color);
}

const _movies = [
  Movie('Fast X', 'Ação', '2023', Color(0xFFFF6B6B)),
  Movie('John Wick 4', 'Ação', '2023', Color(0xFF4ECDC4)),
  Movie('Super Mario Bros', 'Aventura', '2023', Color(0xFFFFD93D)),
  Movie('Oppenheimer', 'Drama', '2023', Color(0xFFA8E6CF)),
  Movie('Barbie', 'Comédia', '2023', Color(0xFFFF6584)),
  Movie('Guardians 3', 'Ação', '2023', Color(0xFF6C63FF)),
];

class MovieProvider extends ChangeNotifier {
  final Set<String> _favorites = {};

  bool isFavorite(String title) => _favorites.contains(title);
  int get favoriteCount => _favorites.length;
  List<String> get favoriteList => _favorites.toList();

  void toggle(String title) {
    if (_favorites.contains(title)) {
      _favorites.remove(title);
    } else {
      _favorites.add(title);
    }
    notifyListeners();
  }
}

// ─── Screen ─────────────────────────────────────────────────────────────────

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  static const _code = '''// 1. Criar o Provider
class MovieProvider extends ChangeNotifier {
  final Set<String> _favorites = {};

  bool isFavorite(String title)
      => _favorites.contains(title);
  int get favoriteCount
      => _favorites.length;

  void toggle(String title) {
    if (_favorites.contains(title)) {
      _favorites.remove(title);
    } else {
      _favorites.add(title);
    }
    notifyListeners();
  }
}

// 2. Disponibilizar na árvore
ChangeNotifierProvider(
  create: (_) => MovieProvider(),
  child: MyApp(),
)

// 3. Consumir em qualquer widget filho
// Leitura + escuta de mudanças:
context.watch<MovieProvider>().favoriteCount

// Apenas ação (sem rebuild):
context.read<MovieProvider>().toggle(title)''';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: Builder(
        builder: (context) {
          final isWide = MediaQuery.of(context).size.width > 1000;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.share_rounded,
                  color: Color(0xFF4ECDC4),
                  title: 'Provider',
                  subtitle: 'Estado de aplicação compartilhado entre widgets',
                  tag: 'app state',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    'O Provider disponibiliza estado para toda a subárvore de widgets. '
                    'Widgets em diferentes partes da árvore leem e modificam o mesmo estado, '
                    'de forma reativa. Note que o FavoriteCounter e a MovieGrid são widgets IRMÃOS.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.codeBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                        child: _FavoriteCounter(),
                      ),
                      const Divider(height: 1),
                      if (isWide)
                        SizedBox(
                          height: 480,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CodeViewer(code: _code),
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              const Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: SingleChildScrollView(
                                    child: _MovieGrid(),
                                  ),
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
                              child: SizedBox(
                                height: 400,
                                child: CodeViewer(code: _code),
                              ),
                            ),
                            const Divider(height: 1),
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: _MovieGrid(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteCounter extends StatelessWidget {
  const _FavoriteCounter();

  @override
  Widget build(BuildContext context) {
    final count = context.watch<MovieProvider>().favoriteCount;
    final list = context.watch<MovieProvider>().favoriteList;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.favorite_rounded,
            color: Color(0xFF4ECDC4),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FavoriteCounter Widget',
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              count == 0
                  ? 'Nenhum favorito'
                  : '$count favorito${count > 1 ? 's' : ''}',
              style: GoogleFonts.inter(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (list.isNotEmpty)
          Wrap(
            spacing: 4,
            children: list
                .take(3)
                .map(
                  (m) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      m,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF4ECDC4),
                        fontSize: 11,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(width: 12),
        Text(
          '← context.watch<MovieProvider>()',
          style: GoogleFonts.firaCode(
            color: AppTheme.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _MovieGrid extends StatelessWidget {
  const _MovieGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'MovieGrid Widget',
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              'context.read<MovieProvider>().toggle()',
              style: GoogleFonts.firaCode(
                color: AppTheme.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: _movies.map((m) => _MovieCard(movie: m)).toList(),
        ),
      ],
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<MovieProvider>().isFavorite(movie.title);
    return GestureDetector(
      onTap: () => context.read<MovieProvider>().toggle(movie.title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isFav
              ? movie.color.withValues(alpha: 0.15)
              : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isFav
                ? movie.color.withValues(alpha: 0.6)
                : AppTheme.codeBorder,
            width: isFav ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(isFav),
                color: isFav ? movie.color : AppTheme.textSecondary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    movie.genre,
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
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
