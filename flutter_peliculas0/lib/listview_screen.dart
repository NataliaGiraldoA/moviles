//stle
import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
   final options = const [
   'Megaman',
   'Metal Gear',
   'Super Smash',
   'Final Fantasy',
 ];

  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de peliculas"),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      
      body: ListView(
        children: [
          /*
          Text("Lista de peliculas"),
          Text("Lista de peliculas"),
          Text("Lista de peliculas"),
          */
          ...options.map(
            (juego) => ListTile(
              leading: Icon(Icons.access_alarm),
              tileColor: Color(0xFFFF9000),
              title: Text(juego),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
          ),
          ListTile(
           leading: Icon(Icons.lock_clock),
           title: Text('Texto'),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
         )
        ],
      ),
      
      );
  }
}