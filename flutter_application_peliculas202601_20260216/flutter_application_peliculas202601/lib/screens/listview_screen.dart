
import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/providers/ricky_morty_provider.dart';
import 'package:provider/provider.dart';


class ListviewScreen extends StatelessWidget {
 final options = const [
   'Megaman',
   'Metal Gear',
   'Super Smash',
   'Final Fantasy',
 ];


 const ListviewScreen({super.key});


 @override
 Widget build(BuildContext context) {
   final characterProvider = Provider.of<RickMortyProvider>(context);


   print(characterProvider.onDisplayCharacter);


   return Scaffold(
     appBar: AppBar(title: const Text('Personajes Rick and Morty'),),


     /*
     body: ListView.separated(
       itemBuilder: (context, index) => CustomCardType2(
         name: characterProvider.onDisplayCharacter[index].name,
         imageUrl: characterProvider.onDisplayCharacter[index].image,
       ),


       separatorBuilder: (context, index) =>
           const Divider(color: Colors.blue, thickness: 0),
       itemCount: characterProvider.onDisplayCharacter.length,
     ),
     */


    
     body: ListView.builder(
       itemBuilder: (context, index) => ListTile(
         leading: Image.network(
           characterProvider.onDisplayCharacter[index].image,
           width: 40,
           height: 40,
           fit: BoxFit.cover,
           filterQuality: FilterQuality.high,
           cacheWidth: (40 * MediaQuery.of(context).devicePixelRatio).toInt()
         ),
         title: Text(characterProvider.onDisplayCharacter[index].name),
         trailing: Icon(Icons.arrow_forward_ios_outlined),
       ),


       itemCount: characterProvider.onDisplayCharacter.length,
     ),
    


     /*
     body: ListView(
       children: [
         /*  
      Text('Dato1'),
      Text('Dato2'),
      Text('Dato3'),
      ListTile(
        leading: Icon(Icons.access_alarm),
        tileColor: Color(0xFFFF9000),
        title: Text('Dato4'),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
      )
      */
        
         ...options.map(
           (juego) => ListTile(
             leading: Icon(Icons.access_alarm),
             tileColor: Color(0xFFFF9000),
             title: Text(juego),
             trailing: Icon(Icons.arrow_forward_ios_outlined),
           ),
         ),


        


         /*
         ...options.map(
           (juego) => ListTile(
             leading: Icon(Icons.access_alarm),
             tileColor: Color(0xFFFF9000),
             title: Text(juego),
             trailing: Icon(Icons.arrow_forward_ios_outlined),
           ),
         ),
         */




       ],
     ),
     */


     /*
       body: const Center(
       child: Text('Listview1Screen')),
     */
   );
 }
}
