import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/sub_menu.dart';

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
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CupertinoButton(
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => widget.destinationClass))
          },
          color: widget.hasCompleted
              ? const Color.fromRGBO(51, 204, 51, 1)
              : const Color.fromRGBO(153, 255, 153, 1),
          child: Text(widget.title, style: GoogleFonts.maShanZheng(fontSize: 20)),
        ),
      ),
    );
  }
}
