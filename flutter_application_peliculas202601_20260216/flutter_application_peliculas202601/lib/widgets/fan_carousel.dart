import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';

class FanCarousel extends StatelessWidget {
  const FanCarousel({super.key});

  static const List<String> images = [
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FanCarouselImageSlider.sliderType1(
        imagesLink: images, 
        isAssets: false,
        autoPlay: true,
        sliderHeight: 400,
        showIndicator: true,
        userCanDrag: true,),
    );
  }
}



