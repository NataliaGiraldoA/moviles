import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class Carousel extends StatelessWidget {
  final List<String> images;

  const Carousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (images.isEmpty) {
     return SizedBox(
       width: double.infinity,
       height: size.height * 0.5,
       child: const Center(child: CircularProgressIndicator(color: Color(0xFFE040FB))),
     );
   }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: CarouselSlider.builder(
        slideBuilder: (int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(images[index % images.length]),
              fit: BoxFit.cover,
            ),
          );
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