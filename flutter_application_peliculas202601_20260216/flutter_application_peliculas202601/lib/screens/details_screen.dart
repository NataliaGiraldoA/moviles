import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/models/models.dart';
import 'package:flutter_application_peliculas202601/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _CinematicHeader(movie: movie),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _GlassInfoCard(movie: movie),
                _CircularRating(movie: movie),
                _StylizedOverview(movie: movie),
                _CinematicCastList(movieId: movie.id),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _CinematicHeader extends StatelessWidget {
  final Movie movie;
  const _CinematicHeader({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: size.height * 0.55,
      floating: false,
      pinned: true,
      stretch: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.fullBackdropPath),
              fit: BoxFit.cover,
            ),
            // Gradiente dramático
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 0.7, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xAA0D0D0D),
                    Color(0xFF0D0D0D),
                  ],
                ),
              ),
            ),
            // Gradiente lateral
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.3, 0.7, 1.0],
                  colors: [
                    Color(0x880D0D0D),
                    Colors.transparent,
                    Colors.transparent,
                    Color(0x880D0D0D),
                  ],
                ),
              ),
            ),
            // Poster y título en la parte inferior
            Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Poster flotante con sombra
                  Hero(
                    tag: movie.heroId ?? 'no-hero-${movie.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE040FB).withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: FadeInImage(
                          placeholder: const AssetImage('assets/no-image.jpg'),
                          image: NetworkImage(movie.fullPosterImg),
                          height: 200,
                          width: 133,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Título y metadata
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (movie.originalTitle != movie.title) ...[
                            const SizedBox(height: 4),
                            Text(
                              movie.originalTitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.5),
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 10),
                          // Chips de info
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _InfoChip(
                                icon: Icons.calendar_month_rounded,
                                label: movie.releaseDate?.substring(0, 4) ?? '—',
                              ),
                              _InfoChip(
                                icon: Icons.translate_rounded,
                                label: movie.originalLanguage.toUpperCase(),
                              ),
                              if (movie.adult)
                                const _InfoChip(
                                  icon: Icons.eighteen_up_rating,
                                  label: '+18',
                                  color: Colors.redAccent,
                                ),
                            ],
                          ),
                        ],
                      ),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({required this.icon, required this.label, this.color = const Color(0xFFE040FB)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── TARJETA GLASS CON ESTADÍSTICAS ──────────────────────────────────────────
class _GlassInfoCard extends StatelessWidget {
  final Movie movie;
  const _GlassInfoCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  icon: Icons.people_alt_rounded,
                  value: _formatNumber(movie.voteCount),
                  label: 'Votos',
                ),
                Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                _StatItem(
                  icon: Icons.trending_up_rounded,
                  value: movie.popularity.toStringAsFixed(0),
                  label: 'Popularidad',
                ),
                Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                _StatItem(
                  icon: Icons.star_rounded,
                  value: movie.voteAverage.toStringAsFixed(1),
                  label: 'Puntuación',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFE040FB), size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5)),
        ),
      ],
    );
  }
}

// ─── RATING CIRCULAR ─────────────────────────────────────────────────────────
class _CircularRating extends StatelessWidget {
  final Movie movie;
  const _CircularRating({required this.movie});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFE040FB);
    final percentage = (movie.voteAverage / 10).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: CustomPaint(
              painter: _RatingPainter(percentage: percentage, color: color),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                    Text(
                      '/10',
                      style: TextStyle(
                        fontSize: 11,
                        color: color.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${movie.voteCount} valoraciones',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingPainter extends CustomPainter {
  final double percentage;
  final Color color;
  _RatingPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Fondo del círculo
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;
    canvas.drawCircle(center, radius, bgPaint);

    // Arco de progreso
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percentage,
      false,
      fgPaint,
    );

    // Glow morado
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percentage,
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─── SINOPSIS ESTILIZADA ─────────────────────────────────────────────────────
class _StylizedOverview extends StatelessWidget {
  final Movie movie;
  const _StylizedOverview({required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie.overview.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFE040FB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'SINOPSIS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE040FB),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            movie.overview,
            style: TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CAST CON DISEÑO CINEMÁTICO ──────────────────────────────────────────────
class _CinematicCastList extends StatelessWidget {
  final int movieId;
  const _CinematicCastList({required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFFE040FB)),
            ),
          );
        }

        final cast = snapshot.data!;
        if (cast.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE040FB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'REPARTO',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFE040FB),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cast.length,
                itemBuilder: (_, int index) {
                  final actor = cast[index];
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE040FB).withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                FadeInImage(
                                  placeholder: const AssetImage('assets/no-image.jpg'),
                                  image: NetworkImage(actor.fullProfilePath),
                                  height: 145,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                                // Gradiente inferior
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  height: 50,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.transparent, Colors.black87],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          actor.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        if (actor.character != null && actor.character!.isNotEmpty)
                          Text(
                            actor.character!,
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(0xFFE040FB).withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}