
import 'dart:ui';

import 'package:flutter/material.dart';

class PageItem extends StatelessWidget {
  const PageItem({
    super.key,
    required this.imageSrc,
  });

  final String imageSrc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: SizedBox(
                height: 420,
                width: 300,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 20, tileMode: TileMode.decal),
                  child: Image.asset(
                    imageSrc,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 42,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Image.asset(
                  opacity: AlwaysStoppedAnimation(1),
                  imageSrc,
                  width: 336,
                  height: 440,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


