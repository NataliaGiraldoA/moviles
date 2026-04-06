import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;

  const CardContainer({
    super.key, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 24 ),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: _createCardShape(),
          
          // ignore: unnecessary_this
          child: this.child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: const Color(0xFF1A1A2E),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: const Color(0xFFE040FB).withValues(alpha: 0.3),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.35),
        blurRadius: 24,
        offset: const Offset(0, 10),
      )
    ]
  );
}
