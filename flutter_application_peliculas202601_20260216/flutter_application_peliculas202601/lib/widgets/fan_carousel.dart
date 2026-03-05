import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class FanCarousel extends StatefulWidget {
  final List<Movie> movies;

  const FanCarousel({super.key, required this.movies});

  @override
  State<FanCarousel> createState() => _FanCarouselState();
}

class _FanCarouselState extends State<FanCarousel> {
  int _currentIndex = 1;
  Offset? _downPosition;

  void _navigateToDetail() {
    if (_currentIndex >= 0 && _currentIndex < widget.movies.length) {
      final movie = widget.movies[_currentIndex];
      movie.heroId = 'fan-${movie.id}';
      Navigator.pushNamed(context, 'detail', arguments: movie);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final imagesLink = widget.movies.map((m) => m.fullPosterImg).toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;
          if (metrics is PageMetrics) {
            final page = metrics.page?.round() ?? _currentIndex;
            if (page >= 0 && page < widget.movies.length) {
              _currentIndex = page;
            }
          }
        }
        return false;
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          _downPosition = event.position;
        },
        onPointerUp: (event) {
          if (_downPosition != null) {
            final distance = (event.position - _downPosition!).distance;
            // Solo navegar si fue un tap (no un drag)
            if (distance < 10) {
              _navigateToDetail();
            }
          }
          _downPosition = null;
        },
        child: IgnorePointer(
          ignoring: false,
          child: FanCarouselImageSlider.sliderType1(
            imagesLink: imagesLink,
            isAssets: false,
            autoPlay: true,
            sliderHeight: 400,
            showIndicator: true,
            userCanDrag: true,
            showArrowNav: true,
            isClickable: false,
            initalPageIndex: 1,
          ),
        ),
      ),
    );
  }
}



