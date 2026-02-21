//stle

import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //return Container();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en Cines'),
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),

      /*
      body: Center(
        child: Text('Home Screen')
      )
      */
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Text('Encabezado - Swiper'),
            CardSwiper(),

            Text('Detalle'),
            FanCarousel(),

            Text('Detalle1'),
            Carousel(),

            Text('Detalle2'),
            TinderSwiper(),

          ],
        ),
      ),

      /*
      body: Column(
        children: [
          //Text('Encabezado - Swiper'),
          CardSwiper(),

          Text('Detalle'),
          CardSwiper()
        ],
      )
      */

      /*
      body:Column(
       children: [
         Text('Encabezado - Swiper'),
         //CardSwiper(),


         Text('Detalle')
       ],
      
     )
     */
    );
  }
}
