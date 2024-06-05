import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SquareOverlay extends StatelessWidget {
  final double size;
  final Color overlayColor;
  final double iconOpacity;
  final double borderWidth;

  const SquareOverlay({
    super.key,
    required this.size,
    this.overlayColor = Colors.grey,
    this.iconOpacity = 0.5,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SvgPicture.asset(
            'assets/overlay.svg', // Path to your SVG file
            // width: 384,
            // height: 550,
          ),
        ),
        Center(
          child: Center(
            child: Icon(
              Icons.remove_red_eye,
              size: size / 4,
              color: Colors.white.withOpacity(iconOpacity),
            ),
          ),
        ),
      ],
    );
  }
}
