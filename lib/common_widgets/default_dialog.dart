import 'package:agriworx/constants/constants.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:flutter/material.dart';

class DefaultDialog extends StatelessWidget {
  const DefaultDialog({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(dialogPadding),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: dialogMinSize,
                maxWidth: dialogMaxWidth,
                minHeight: dialogMinSize,
              ),
              decoration: BoxDecoration(
                color: ColorPalette.card,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(title, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(height: 20),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
