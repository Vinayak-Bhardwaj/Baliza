import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  String text;
  void Function()? pressed;
  Color color;

  RoundedButton({required this.text, required this.pressed, this.color = const Color(0xFF6F35A5)});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height*0.01219),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size.height*0.0353),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: size.height*0.0243, horizontal: size.width*0.0973),
            primary: color,
            backgroundColor: color,
            onSurface: color,
          ),
          onPressed: pressed,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
