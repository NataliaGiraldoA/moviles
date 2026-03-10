import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/providers/movie_provider.dart';
import 'package:flutter_application_peliculas202601/providers/ricky_morty_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<RickMortyProvider>(context);
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final imageUrls =
        characterProvider.onDisplayCharacter.map((c) => c.image).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_filter_rounded, color: Color(0xFFE040FB), size: 26),
            SizedBox(width: 8),
            Text(
              'CINES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),

            // --- En Cartelera ---
            _SectionHeader(icon: Icons.local_fire_department_rounded, title: 'EN CARTELERA'),
            CardSwiper(movies: moviesProvider.onDisplayMovies),

            const SizedBox(height: 10),

            // --- Populares ---
            _SectionHeader(icon: Icons.star_rounded, title: 'POPULARES'),
            FanCarousel(movies: moviesProvider.popularMovies),

            const SizedBox(height: 10),

            // --- Personajes ---
            _SectionHeader(icon: Icons.people_rounded, title: 'PERSONAJES'),
            Carousel(images: imageUrls),

            const SizedBox(height: 10),

            // --- Rick y Morty Temporadas ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, 'seasons'),
                  icon: const Icon(Icons.tv_rounded),
                  label: const Text('Rick y Morty - Temporadas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE040FB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- Próximamente ---
            _SectionHeader(icon: Icons.upcoming_rounded, title: 'PRÓXIMAMENTE'),
            TinderSwiper(movies: moviesProvider.upcomingMovies),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE040FB).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFE040FB), size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE040FB),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFE040FB).withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
