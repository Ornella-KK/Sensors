import 'package:flutter/material.dart';

class NeuCircle extends StatelessWidget {
  final Widget child;
  final Color circleColor;

  const NeuCircle({
    Key? key,
    required this.child,
    this.circleColor = const Color(0xFFC3F8BC),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final shadowColor = isDarkMode ? const Color.fromARGB(143, 255, 255, 255) : Color.fromARGB(123, 8, 53, 15);

    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      margin: EdgeInsets.all(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: shadowColor,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 6, 65, 15),
            Color.fromARGB(255, 3, 68, 14),
            Color.fromARGB(255, 8, 53, 15),
            Color.fromARGB(255, 2, 48, 10),
            
          ],
          stops: [0.1, 0.3, 0.8, 1],
        ),
      ),
      child: child,
    );
  }
}
