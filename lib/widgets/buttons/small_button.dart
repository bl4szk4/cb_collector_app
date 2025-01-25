import 'package:flutter/material.dart';

class HalfWidthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const HalfWidthButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      height: 50, // Half the height of FullWidthButton
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C68AF), Color(0xFF0B4F85)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20, // Slightly smaller font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
