import 'package:flutter/material.dart';
import '/components/list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  final void Function()? onWriteArticleTap;
  final String currentUserEmail;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
    required this.onWriteArticleTap,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff6665DD),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Header
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              Container(
                color: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "Logged in as $currentUserEmail",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Home list
              MyListTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),
              // User profile
              MyListTile(
                icon: Icons.person,
                text: "P R O F I L E",
                onTap: onProfileTap,
              ),
              // Write article
              MyListTile(
                icon: Icons.post_add,
                text: "P O S T   A R T I C L E",
                onTap: onWriteArticleTap,
              ),
            ],
          ),
          // Logout
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              text: "L O G O U T",
              onTap: () {
                if (onSignOut != null) {
                  onSignOut!(); // Call the sign out function
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
