import 'package:agriworx/constants/constants.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:flutter/material.dart';

class DefaultDialog extends StatelessWidget {
  const DefaultDialog({
    super.key,
    required this.title,
    required this.child,
    required this.hasCloseButton,
  });

  final String title;
  final Widget child;
  final bool hasCloseButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          SingleChildScrollView(
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
          if (hasCloseButton)
            Positioned(
              right: 10,
              top: 10,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: FittedBox(
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 36,
                    ),
                    onPressed: () {
                      print('POP');
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
