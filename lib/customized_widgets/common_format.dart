import 'package:flutter/material.dart';

/// centered with padding
class CommonFormat extends StatelessWidget {
  final Widget child;

  const CommonFormat({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(child: child),
    );
  }
}