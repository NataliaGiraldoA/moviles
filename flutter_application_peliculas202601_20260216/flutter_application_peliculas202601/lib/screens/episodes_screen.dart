import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/models/tv_season.dart';
import 'package:flutter_application_peliculas202601/providers/movie_provider.dart';
import 'package:provider/provider.dart';

class EpisodesScreen extends StatelessWidget {
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int seasonNumber =
        ModalRoute.of(context)!.settings.arguments as int;
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<TvSeasonDetail>(
        future: moviesProvider.getRickAndMortySeason(seasonNumber),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final seasonDetail = snapshot.data!;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    seasonDetail.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeInImage(
                        placeholder: const AssetImage('assets/no-image.jpg'),
                        image: NetworkImage(
                          seasonDetail.posterPath != null
                              ? 'https://image.tmdb.org/t/p/w500${seasonDetail.posterPath}'
                              : 'https://i.stack.imgur.com/GNhxO.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 1.0],
                            colors: [Colors.transparent, Colors.black87],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (seasonDetail.overview.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      seasonDetail.overview,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.white70, height: 1.4),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final episode = seasonDetail.episodes[index];
                    return _EpisodeCard(episode: episode);
                  },
                  childCount: seasonDetail.episodes.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        },
      ),
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  final TvEpisode episode;

  const _EpisodeCard({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF1A1A2E),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del episodio
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: Stack(
              children: [
                FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(episode.fullStillPath),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                // Número de episodio
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE040FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'E${episode.episodeNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                // Duración
                if (episode.runtime != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            '${episode.runtime} min',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Info del episodio
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      episode.voteAverage.toStringAsFixed(1),
                      style:
                          const TextStyle(fontSize: 13, color: Colors.amber),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${episode.voteCount} votos)',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                    const Spacer(),
                    if (episode.airDate != null)
                      Text(
                        episode.airDate!,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white54),
                      ),
                  ],
                ),
                if (episode.overview.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    episode.overview,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.white60, height: 1.4),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
