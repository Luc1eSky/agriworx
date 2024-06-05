import 'package:agriworx/style/color_palette.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../domain/fertilizer.dart';

class FertilizerWidget extends StatelessWidget {
  const FertilizerWidget({
    super.key,
    required this.fertilizer,
    this.isCurrentlySelected = false,
  });

  final Fertilizer? fertilizer;
  final bool isCurrentlySelected;

  @override
  Widget build(BuildContext context) {
    final f = fertilizer;
    return AspectRatio(
      aspectRatio: fertilizerWidgetAspectRatio,
      child: f == null
          ? Container(
              color: ColorPalette.emptySpace,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: FittedBox(
                  child: Icon(
                    Icons.add_box_outlined,
                    size: 100,
                    color: ColorPalette.addSymbol,
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  color: f.color,
                  border: isCurrentlySelected
                      ? Border.all(
                          color: ColorPalette.selectedFertilizer,
                          width: 5,
                        )
                      : null),
              child: Center(
                child: Text(f.name),
              ),
            ),
    );
  }
}
