import 'package:flutter/material.dart';

import '../constants/constants.dart';

class SmallDialog extends StatelessWidget {
  const SmallDialog({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      contentPadding: const EdgeInsets.all(16),
      insetPadding: const EdgeInsets.all(60),
      children: [
        SizedBox(
          width: dialogMaxWidth,
          child: child,
        )
      ],
    );
  }
}
