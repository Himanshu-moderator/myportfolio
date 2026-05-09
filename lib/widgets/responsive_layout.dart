import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.mobile) {
          return mobileBody;
        } else if (constraints.maxWidth < AppBreakpoints.tablet) {
          return tabletBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}