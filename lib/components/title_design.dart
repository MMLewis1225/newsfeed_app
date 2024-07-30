import 'package:flutter/material.dart';

class TitleDesign extends StatelessWidget {
  final String text;

  const TitleDesign({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // White text
        Positioned(
          bottom: 1.5,
          left: 0.5,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Black text
        Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
