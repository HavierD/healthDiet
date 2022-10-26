import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_diet/sub_menu/milk_menu.dart';

class MenuButton extends StatefulWidget {
  final String title;
  final dynamic destinationClass;
  final bool hasCompleted;

  const MenuButton({
    Key? key,
    required this.title,
    required this.destinationClass,
    required this.hasCompleted,
  }) : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      onPressed: widget.hasCompleted ? null : () =>
      {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget.destinationClass))
      },
      child: const Text("奶类"),
    );
  }
}
