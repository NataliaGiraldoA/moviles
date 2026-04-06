//stles Widgets

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  //const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    //return const Placeholder();
    // ignore: sized_box_for_whitespace
    return Container(

      /*
      color: Colors.green,
      width: double.infinity,
      height: double.infinity,
      */
      
      child: Stack(
        children: [
          _PurpleBox(),

          _HeaderIcon(),

          // ignore: unnecessary_this
          this.child,

          
          //Ctrl + .
          //NewWidgetOtro()
          


        ],
      ),
      


    );
  }
}

class NewWidgetOtro extends StatelessWidget {
  const NewWidgetOtro({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.blue,
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 34),
        child: const Icon(
          Icons.movie_filter_rounded,
          color: Color(0xFFE040FB),
          size: 92,
        ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  //const _PurpleBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      //color: Colors.indigo,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          //_Bubble(),
          Positioned(top: 90, left: 30, child: _Bubble()),
          Positioned(top: -40, left: -30, child: _Bubble()),
          Positioned(top: -50, right: -20, child: _Bubble()),
          Positioned(bottom: -50, left: 10, child: _Bubble()),
          Positioned(bottom: 120, right: 20, child: _Bubble()),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF111124), Color(0xFF1A1A2E), Color(0xFF221637)],
    ),
  );
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color(0xFFE040FB).withValues(alpha: 0.09),
      ),
    );
  }
}
