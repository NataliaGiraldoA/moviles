import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

import '../models/models.dart';

class TinderSwiper extends StatelessWidget {
  final List<Movie> movies;

  const TinderSwiper({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: const Center(child: CircularProgressIndicator(color: Color(0xFFE040FB))),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: AppinioSwiper(
        cardCount: movies.length,
        cardBuilder: (BuildContext context, int index) {
          final movie = movies[index % movies.length];
          movie.heroId = 'tinder-${movie.id}';
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'detail', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE040FB).withValues(alpha: 0.2),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(movie.fullPosterImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}