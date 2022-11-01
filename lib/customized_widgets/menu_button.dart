import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                context, MaterialPageRoute(builder: (context) => widget.destinationClass)
            )
          },
          color: widget.hasCompleted
              ? const Color.fromRGBO(68, 159, 40, 1.0)
              : const Color.fromRGBO(136, 176, 140, 1.0),
          child: Row(
            children: [
              Text(widget.title, style: GoogleFonts.maShanZheng(fontSize: 20)),
              widget.hasCompleted ? const Icon(Icons.check) : const Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
