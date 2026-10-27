import 'package:flutter/material.dart';

/// Membatasi lebar konten (default 480 px) dan memusatkannya, supaya tampilan
/// tetap rapi di HP, tablet, Chrome, maupun jendela Windows yang lebar.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, required this.child, this.maxWidth = 480});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth > maxWidth ? maxWidth : constraints.maxWidth;
        return Center(
          child: SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: child,
          ),
        );
      },
    );
  }
}
