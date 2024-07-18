import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final isLeftButton;

  const CustomElevatedButton({
    required this.title,
    required this.onPressed,
    required this.isLeftButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isLeftButton ? Colors.white : Colors.blue,
        // Background color
        foregroundColor: !isLeftButton ? Colors.white : Colors.blue,
        // Text color
        textStyle: TextStyle(fontSize: 18),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero), // No rounded corners
      ),
      child: Text(title, textAlign: TextAlign.center),
    );
  }
}
