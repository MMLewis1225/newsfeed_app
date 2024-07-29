import 'package:flutter/material.dart';

class NewsPost extends StatelessWidget {
  final String message;
  final String user;
  final String time;

  const NewsPost({
    super.key,
    required this.message,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns at the top of the Row
        children: [
          Expanded(
            // This makes the Column take all available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user, style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 10),
                Text(
                  message,
                  maxLines: null, // Allows the text to wrap
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 10),
                Text(time),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
