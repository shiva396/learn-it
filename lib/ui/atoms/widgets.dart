import 'package:flutter/material.dart';

Text text(String text, double size, Color color, int family) {
  return Text(
    text,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: (() {
        switch (family) {
          case 1:
        return 'mont';
          case 2:
        return 'mont2';
          default:
        return 'mont3';
        }
      })(),
    ),
  );
}

