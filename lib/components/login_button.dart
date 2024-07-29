import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const LoginButton({super.key, required this.onTap, required this.text});

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        widget.onTap(); // Call the onTap callback
      },
      onTapCancel: () => _setPressed(false),
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey[800] : Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            widget.text, // Use the text parameter
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _setPressed(bool isPressed) {
    setState(() {
      _isPressed = isPressed;
    });
  }
}
