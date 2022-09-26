import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;

  const DefaultLayout({
    Key? key,
    required this.body,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: body,
    );
  }
}
