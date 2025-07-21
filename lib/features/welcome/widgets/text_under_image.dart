import 'package:flutter/material.dart';
import 'package:image_generate/theme.dart';

class UnderPagesText extends StatelessWidget {
  const UnderPagesText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Unlock the Power Of Future AI',
            textAlign: TextAlign.center,
            style: context.appPoppinsTextTheme.headlineSmall,
          ),
          Text(
            'Chat with the smartest AI Future          Experience power of AI with us',
            textAlign: TextAlign.center,
            style: context.appPoppinsTextTheme.bodySmall!.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
