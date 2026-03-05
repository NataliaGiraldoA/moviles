//stle

import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/providers/movie_provider.dart';
import 'package:flutter_application_peliculas202601/providers/ricky_morty_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<RickMortyProvider>(context);
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final imageUrls = characterProvider.onDisplayCharacter
        .map((c) => c.image)
        .toList();

    final imageMovieUrls = moviesProvider.onDisplayMovies
        .map((c) => c.fullPosterImg)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en Cines'),
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onDisplayMovies),

            Text('Detalle'),
            FanCarousel(movies: moviesProvider.popularMovies),

            Text('Detalle1'),
            Carousel(images: imageUrls),

            Text('Detalle2'),
            TinderSwiper(movies: moviesProvider.upcomingMovies),

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
