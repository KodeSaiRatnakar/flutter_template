import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  SubmitButton({required this.text, required this.fontSize, super.key});
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.amber)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: fontSize),
        ),
      ),
    );
  }
}
