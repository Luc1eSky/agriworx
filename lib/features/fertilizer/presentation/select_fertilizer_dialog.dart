import 'dart:math';

import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:agriworx/features/fertilizer/presentation/fertilizer_widget.dart';
import 'package:agriworx/features/fertilizer/presentation/select_amount_dialog.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../constants/fertilizer_options.dart';
import '../domain/amount.dart';
import '../domain/fertilizer.dart';

class SelectFertilizerDialog extends StatelessWidget {
  const SelectFertilizerDialog({
    super.key,
    required this.weekNumber,
    required this.index,
    this.fertilizerSelection,
  });

  final int weekNumber;
  final int index;
  final FertilizerSelection? fertilizerSelection;

  @override
  Widget build(BuildContext context) {
    // create fertilizer widget list
    final fertilizerWidgets = createFertilizerWidgets(
      weekNumber: weekNumber,
      index: index,
      selectedFertilizer: fertilizerSelection?.fertilizer,
      selectedAmount: fertilizerSelection?.amount,
      context: context,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: dialogHorizontalPadding,
        vertical: dialogVerticalPadding,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final availableWidth =
            min(maxWidth, dialogMaxWidth + 2 * dialogContentPadding);
        final crossAxisCount =
            (availableWidth / fertilizerWidgetMaxWidth).round();
        final itemWidth = (availableWidth -
                2 * dialogContentPadding -
                (crossAxisCount - 1) * fertilizerWidgetSpacing) /
            crossAxisCount;

        final rowCount = (fertilizerWidgets.length / crossAxisCount).ceil();
        final areaHeight =
            rowCount * (itemWidth / fertilizerWidgetAspectRatio) +
                (rowCount - 1) * fertilizerWidgetSpacing +
                2 * dialogContentPadding;
        final availableHeight = min(maxHeight, areaHeight * 1.2);

        return SimpleDialog(
          title: const Text('Choose Fertilizer'),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: availableWidth,
              height: availableHeight,
              child: GridView.count(
                padding: const EdgeInsets.all(dialogContentPadding),
                childAspectRatio: fertilizerWidgetAspectRatio,
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: fertilizerWidgetSpacing,
                crossAxisSpacing: fertilizerWidgetSpacing,
                children: fertilizerWidgets,
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// create fertilizer widget list
List<Widget> createFertilizerWidgets({
  required int weekNumber,
  required int index,
  required Fertilizer? selectedFertilizer,
  required Amount? selectedAmount,
  required BuildContext context,
}) {
  return availableFertilizers.map((f) {
    final isNew = selectedFertilizer == null;
    final rememberedAmount = isNew ? null : selectedAmount;
    return GestureDetector(
      onTap: () {
        print('-----');
        print('new fertilizer: $f');
        print('rememberedAmount: $rememberedAmount');
        print('week: $weekNumber');
        print('index: $index');
        print('isNew: $isNew');
        print('-----');
        showDialog(
            context: context,
            builder: (context) {
              return SelectAmountDialog(
                weekNumber: weekNumber,
                index: index,
                fertilizer: f,
                amount: rememberedAmount,
                isNew: isNew,
              );
            });
      },
      child: FertilizerWidget(
        fertilizer: f,
        isCurrentlySelected: f == selectedFertilizer,
      ),
    );
  }).toList();
}
