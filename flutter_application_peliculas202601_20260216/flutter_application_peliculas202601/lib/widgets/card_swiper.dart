import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';


import '../models/models.dart';


class CardSwiper extends StatelessWidget {
 final List<Movie> movies;


 const CardSwiper({super.key, required this.movies});


 /*
 @override
 Widget build(BuildContext context) {
   //return const Placeholder();


   print(movies);


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
        
         /*
         return GestureDetector(
           onTap: () => Navigator.pushNamed(
             context,
             'detail',
             arguments: 'movie-instance',
           ),
           child: ClipRRect(
             borderRadius: BorderRadius.circular(20),
             child: FadeInImage(
               placeholder: AssetImage('assets/no-image.jpg'),
               image: //AssetImage('assets/pelicula.jpg'),
               NetworkImage('https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'),
               //width: 130,
               //height: 190,
               fit: BoxFit.cover,
             ),
           ),
         );
         */


       },
     ),
   );
  




 }
 */


 @override
 Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size;


   if (movies.isEmpty) {
     return SizedBox(
       width: double.infinity,
       height: size.height * 0.5,
       child: Center(child: CircularProgressIndicator()),
     );
   }


   return SizedBox(
     width: double.infinity,
     height: size.height * 0.5,
     child: Swiper(
       itemCount: movies.length,
       layout: SwiperLayout.STACK,
       itemWidth: size.width * 0.6,
       itemHeight: size.height * 0.4,




       itemBuilder: (_, int index) {
         final movie = movies[index];


         movie.heroId = 'swiper-${movie.id}';


         return GestureDetector(
           onTap: () =>
               Navigator.pushNamed(context, 'detail', arguments: movie),
           child: Hero(
             tag: movie.heroId!,
             child: ClipRRect(
               borderRadius: BorderRadius.circular(20),
               child: FadeInImage(
                 placeholder: AssetImage('assets/no-image.jpg'),
                 image: NetworkImage(movie.fullPosterImg),
                 fit: BoxFit.cover,
               ),
             ),
           ),
         );
       },
     ),
   );
 }
}
