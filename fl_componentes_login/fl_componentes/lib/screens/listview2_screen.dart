import 'package:flutter/material.dart';

class Listview2Screen extends StatelessWidget {
  final options = const [
    'Megaman',
    'Metal Gear',
    'Super Smash',
    'Final Fantasy',
  ];

  const Listview2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista 2')),

      body: ListView.separated(

        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.access_time_sharp, color: Colors.red),
          title: Text(options[index]),
          trailing: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.indigo,
          ),

          onTap: () {
            final juego = options[index];
            print(juego);
          },
        ),
        separatorBuilder: (context, index) =>
            const Divider(
              color: Colors.blue, 
              thickness: 5
              ),
        itemCount: options.length,
      ),

      /*
      body: const Center(
         child: Text('Listview2Screen'),
      ),
      */
    );
  }
}
