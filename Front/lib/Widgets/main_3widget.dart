import 'package:flutter/material.dart';

class MainFunction extends StatelessWidget {
  final String imageUrl;
  final String text;

  const MainFunction({
    Key? key,
    required this.imageUrl,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imageUrl, scale: 1.3),
            SizedBox(height: 2),
            Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.bold,),
            ),
          ],
        ),
      ),
    );
  }
}


class DayCircle extends StatelessWidget {
  final Color color;
  final String text;

  const DayCircle({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: color,),),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}