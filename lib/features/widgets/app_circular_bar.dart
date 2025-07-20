import 'package:flutter/material.dart';
import 'package:image_generate/theme.dart';

class AppCircularBar extends StatelessWidget {
  const AppCircularBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(
          color: context.appColors.primary.shade300,
        ),
      ),
    );
  }
}
