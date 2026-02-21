import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class TinderSwiper extends StatelessWidget {
  const TinderSwiper({super.key});

  static const List<String> images = [
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
    'https://tse1.explicit.bing.net/th/id/OIP.1ZaFpKFhAFSHLuFo6Zaa5gHaFj?rs=1&pid=ImgDetMain&o=7&rm=3',
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.75,
        child: AppinioSwiper(
          cardCount: images.length,
          cardBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(images[index % images.length]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}