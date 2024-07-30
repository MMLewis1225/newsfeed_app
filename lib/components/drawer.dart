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
                // color: Colors.grey[300],
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFB2FF9E),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  "Logged in as $currentUserEmail",
                  style: const TextStyle(
                    color: Colors.black,
                    //   fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Home list
              MyListTile(
                icon: Icons.home,
                text: "Home",
                onTap: () => Navigator.pop(context),
              ),
              // User profile
              MyListTile(
                icon: Icons.person,
                text: "Profile",
                onTap: onProfileTap,
              ),
              // Write article
              MyListTile(
                icon: Icons.post_add,
                text: "Post Article",
                onTap: onWriteArticleTap,
              ),
            ],
          ),
          // Logout
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              text: "Log Out",
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
