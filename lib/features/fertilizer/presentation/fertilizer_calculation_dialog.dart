import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class FertilizerCalculationDialog extends StatelessWidget {
  const FertilizerCalculationDialog({super.key, required this.weekNumber});

  final int weekNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: dialogPadding,
        vertical: dialogVerticalPadding,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final availableWidth = min(maxWidth, dialogMaxWidth + 2 * dialogContentPadding);

        // TODO: max height
        final availableHeight = min(maxHeight, 500);

        return SimpleDialog(
          title: const Text('Calculate Fertilizers'),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: availableWidth,
              height: availableHeight - 80,
              child: Center(
                child: Container(
                  color: Colors.green,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('xxx N'),
                          Text('xxx P'),
                          Text('xxx K'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Calculate'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
