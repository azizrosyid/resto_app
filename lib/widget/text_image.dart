import 'package:flutter/material.dart';

class TextImage extends StatelessWidget {
  final String image;
  final String message;
  final Function()? onPressed;
  final String messageButton;

  const TextImage({
    super.key,
    required this.image,
    required this.message,
    this.onPressed,
    this.messageButton = 'Button',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 150,
            width: 150,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 8),
          if (onPressed != null)
            ElevatedButton(
              onPressed: onPressed,
              child: Text(messageButton),
            ),
        ],
      ),
    );
  }
}
