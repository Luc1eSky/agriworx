import 'dart:math';

import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:agriworx/features/fertilizer/presentation/select_amount_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constants.dart';
import '../data/fertilizer_options.dart';
import '../domain/amount.dart';
import '../domain/fertilizer.dart';
import 'fertilizer_widget.dart';

class SelectFertilizerDialog extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    // create fertilizer widget list
    final fertilizerWidgets = createFertilizerWidgets(
      weekNumber: weekNumber,
      index: index,
      selectedFertilizer: fertilizerSelection?.fertilizer,
      selectedAmount: fertilizerSelection?.amount,
      context: context,
      fertilizersInWeek: ref
          .read(fertilizerDataRepositoryProvider.notifier)
          .getSelectedFertilizers(weekNumber),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: dialogPadding,
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
              height: availableHeight - 80,
              child: GridView(
                padding: const EdgeInsets.all(dialogContentPadding),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                children: fertilizerWidgets,
              ),
            ),
            if (fertilizerSelection != null)
              SizedBox(
                height: 80,
                child: Center(
                  child: SizedBox(
                    width: 160,
                    height: 50,
                    child: IconButton(
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.orangeAccent),
                      hoverColor: Colors.orange,
                      highlightColor: Colors.deepOrange,
                      onPressed: () {
                        ref
                            .read(fertilizerDataRepositoryProvider.notifier)
                            .removeFertilizerSelection(
                              weekNumber: weekNumber,
                              index: index,
                            );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete),
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

/// create fertilizer widget list
List<Widget> createFertilizerWidgets({
  required int weekNumber,
  required int index,
  required Fertilizer? selectedFertilizer,
  required Amount? selectedAmount,
  required BuildContext context,
  required List<Fertilizer> fertilizersInWeek,
}) {
  return availableFertilizers.map((f) {
    final isClickedFertilizer = f == selectedFertilizer;
    final isAlreadyInWeek =
        !isClickedFertilizer && fertilizersInWeek.contains(f);

    final isNew = selectedFertilizer == null;

    final rememberedAmount = isNew ? null : selectedAmount;
    return GestureDetector(
      onTap: isAlreadyInWeek
          ? null
          : () {
              showDialog(
                context: context,
                builder: (context) {
                  return SelectAmountDialog(
                    amount: selectedAmount,
                    fertilizer: f,
                    weekNumber: weekNumber,
                    index: index,
                  );
                },
              );
            },
      child: FertilizerWidget(
        fertilizer: f,
        isCurrentlySelected: isClickedFertilizer,
        isGreyedOut: isAlreadyInWeek,
      ),
    );
  }).toList();
}
