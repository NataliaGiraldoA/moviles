import 'package:flutter/material.dart';

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
   return Scaffold(
     appBar: AppBar(title: const Text('ListView')),


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
         
       ],
       
     ),


     /*
    body: const Center(
      child: Text('Listview1Screen')),
    */
   );
 }
}



