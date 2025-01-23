import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Icon? icon;

  CustomAppBar({required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        capitalizeFirstLetter(title),
        style: TextStyle(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.brown.shade400,
      elevation: 0.0,
      actions: icon != null
          ? [
        IconButton(
          icon: icon!,
          onPressed: () {
            // Ajouter une action si nécessaire
            print("Icon clicked");
          },
        ),
      ]
          : null, // Pas d'icône si icon est null
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
