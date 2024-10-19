import 'dart:math';

import 'package:flutter/material.dart';

class ErrorImage extends StatelessWidget {
  final String firstLetter;
  const ErrorImage({required this.firstLetter});

  @override
  Widget build(BuildContext context) {
    // Function to generate a random color
    Color getRandomColor() {
      final random = Random();
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }

    return Container(
      color: getRandomColor(), // Random background color
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
