import 'package:flutter/material.dart';

class ScrollImages extends StatefulWidget {
  @override
  _ScrollImagesState createState() => _ScrollImagesState();
}

class _ScrollImagesState extends State<ScrollImages> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Image.asset('images/cooked_food.png', width: size.width),
        Image.asset('images/share1.png', width: size.width),
        Image.asset('images/share2.png', width: size.width),
        Image.asset('images/share3.png', width: size.width),
        Image.asset('images/share4.png', width: size.width),
      ],
    );
  }
}
