import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/componets/my_list_tile.dart';

class MyDrawer extends StatelessWidget {

  final Function()? onProfileTap;
  final Function()? onSignoutTap;

  const MyDrawer({super.key, required this.onProfileTap, required this.onSignoutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(child: Icon(Icons.person, color: Colors.white,size: 64)),
              MyListTile(icon: Icons.home,
                text: 'ANASAYFA',
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(icon: Icons.person,
                text: 'Profil',
                onTap:onProfileTap,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(icon: Icons.logout,
              text: 'Çıkış yap',
              onTap: onSignoutTap,
            ),
          )
        ],
      ),
    );
  }
}
