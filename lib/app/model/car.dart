import 'package:flutter/material.dart';

class CartCounter extends StatelessWidget {
  const CartCounter({super.key, required this.count});
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 0),
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 149, 0),
        shape: BoxShape.circle,
      ),
      child: Text(
        count,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}
