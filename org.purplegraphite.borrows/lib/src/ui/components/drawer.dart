import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(EvaIcons.menu2),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
