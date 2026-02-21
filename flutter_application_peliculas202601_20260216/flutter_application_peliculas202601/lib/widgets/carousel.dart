import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  static const List<String> images = [
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: CarouselSlider.builder(
        slideBuilder: (int index) {
          return Image.network(images[index % images.length], fit: BoxFit.cover);
        },
        itemCount: images.length,
        slideTransform: const CubeTransform(),
        unlimitedMode: true,
        enableAutoSlider: true,
        autoSliderDelay: const Duration(seconds: 3),
        autoSliderTransitionTime: const Duration(milliseconds: 800),
      ),
    );
  }
}