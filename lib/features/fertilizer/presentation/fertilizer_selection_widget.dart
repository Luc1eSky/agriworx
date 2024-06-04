import 'package:agriworx/features/fertilizer/presentation/select_fertilizer_dialog.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../utils/utils.dart';
import '../domain/fertilizer_selection.dart';
import 'amount_widget.dart';
import 'fertilizer_widget.dart';

class FertilizerSelectionWidget extends StatelessWidget {
  const FertilizerSelectionWidget({
    super.key,
    required this.maxWidth,
    required this.weekIndex,
    required this.fertilizerIndex,
    this.fertilizerSelection,
  });

  final double maxWidth;
  final int weekIndex;
  final int fertilizerIndex;
  final FertilizerSelection? fertilizerSelection;

  @override
  Widget build(BuildContext context) {
    final itemWidth = getItemWidth(maxWidth);

    //
    // maxWidth /
    // (maxNumberOfFertilizersPerWeek + (maxNumberOfFertilizersPerWeek + 1) * horizontalGapRatio);

    final aspectRatio = itemWidth /
        (itemWidth / fertilizerWidgetAspectRatio +
            verticalGapRatio * itemWidth +
            amountWidgetHeightRatio * itemWidth);

    return GestureDetector(
      onTap: () {
        print('weekIndex: $weekIndex, fertilizerIndex: $fertilizerIndex');
        showDialog(
            context: context,
            builder: (context) {
              return SelectFertilizerDialog(
                weekNumber: weekIndex,
                index: fertilizerIndex,
                fertilizerSelection: fertilizerSelection,
              );
            });
      },
      child: SizedBox(
        width: itemWidth,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FertilizerWidget(
                fertilizer: fertilizerSelection?.fertilizer,
              ),
              AmountWidget(
                itemWidth: itemWidth,
                amount: fertilizerSelection?.amount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
