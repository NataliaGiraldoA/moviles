import 'package:fl_componentes/providers/ricky_morty_provider.dart';
import 'package:fl_componentes/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<RickMortyProvider>(context);

    print(characterProvider.onDisplayCharacter);

    return Scaffold(
      appBar: AppBar(title: const Text('Screen de Card')),

      /*
      body: Center(
         child: Text('CardScreen'),
      ),
      */
      body: ListView.separated(
        itemBuilder: (context, index) => CustomCardType2(
          name: characterProvider.onDisplayCharacter[index].name,
          imageUrl: characterProvider.onDisplayCharacter[index].image,
        ),

        separatorBuilder: (context, index) =>
            const Divider(color: Colors.blue, thickness: 0),
        itemCount: characterProvider.onDisplayCharacter.length,
      ),

      /*
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        children: const [
          CustomCardType1(),
          SizedBox(height: 10),

          CustomCardType2(
            imageUrl:
                'https://photographylife.com/wp-content/uploads/2017/01/What-is-landscape-photography.jpg',
          ),
          SizedBox(height: 20),

          CustomCardType2(
            imageUrl:
                'https://cdn1.epicgames.com/ue/product/Screenshot/04-1920x1080-d39d5f7af4e17b162383cdf38ce97858.jpg?resize=1&w=1920',
          ),
          SizedBox(height: 20),

          CustomCardType2(
            name: 'Un hermoso paisaje',
            imageUrl:
                'https://photographylife.com/wp-content/uploads/2016/06/Mass.jpg',
          ),
          SizedBox(height: 100),

          CustomCardType2(
            name: 'Rick Sanchez',
            imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
          ),
          SizedBox(height: 100),
        ],
      ),
      */
    );
  }
}
