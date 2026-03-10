import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/models/tv_season.dart';
import 'package:flutter_application_peliculas202601/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class SeasonsScreen extends StatelessWidget {
  const SeasonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick y Morty - Temporadas'),
      ),
      body: FutureBuilder<List<TvSeason>>(
        future: moviesProvider.getRickAndMortySeasons(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final seasons = snapshot.data!
              .where((s) => s.seasonNumber > 0 && s.episodeCount > 0)
              .toList();

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: seasons.length,
            itemBuilder: (context, index) {
              final season = seasons[index];
              return _SeasonCard(season: season);
            },
          );
        },
      ),
    );
  }
}

class _SeasonCard extends StatelessWidget {
  final TvSeason season;

  const _SeasonCard({required this.season});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'episodes', arguments: season.seasonNumber);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A2E),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE040FB).withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Póster de la temporada
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(season.fullPosterPath),
                width: 110,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      season.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.movie_outlined,
                            size: 16, color: Color(0xFFE040FB)),
                        const SizedBox(width: 4),
                        Text(
                          '${season.episodeCount} episodios',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (season.airDate != null)
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Color(0xFFE040FB)),
                          const SizedBox(width: 4),
                          Text(
                            season.airDate!,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    if (season.voteAverage > 0)
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            season.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.amber),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    if (season.overview.isNotEmpty)
                      Text(
                        season.overview,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white54),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: Color(0xFFE040FB)),
            ),
          ],
        ),
      ),
    );
  }
}
