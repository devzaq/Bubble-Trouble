import 'package:flutter/material.dart';

typedef OnButtonPress = void Function();

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.icon, required this.onButtonPress});
  final IconData icon;
  final OnButtonPress onButtonPress;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: Colors.grey[100],
      ),
      onPressed: onButtonPress,
      child: Icon(icon),
    );
    return button;
  }
}
