import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    //return const Placeholder();

    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.5,
      width: double.infinity,

      //color: Colors.red,

      child: Swiper(
        itemCount: 10,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.9,
        itemHeight: size.height * 0.6,

        pagination: SwiperPagination(),
        control: SwiperControl(),

        itemBuilder: (_, int index) {
          return FadeInImage(
            placeholder: AssetImage('assets/no-image.jpg'),
            image: //AssetImage('assets/pelicula.jpg'),
            NetworkImage('https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80')
          );
        },
      ),
    );
  }
}
