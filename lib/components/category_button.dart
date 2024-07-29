import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.black : Colors.white, // Text color
        side: BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // Smaller border radius
        ),
        padding:
            EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
        minimumSize: Size(60, 30), // Smaller minimum size
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12), // Smaller font size
      ),
    );
  }
}
