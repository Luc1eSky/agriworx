import 'dart:math';

import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:agriworx/features/fertilizer/presentation/fertilizer_widget.dart';
import 'package:agriworx/features/fertilizer/presentation/unit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constants.dart';
import '../domain/amount.dart';
import '../domain/fertilizer.dart';
import '../domain/unit.dart';

class SelectAmountDialog extends StatefulWidget {
  const SelectAmountDialog({
    super.key,
    required this.weekNumber,
    required this.index,
    required this.fertilizer,
    this.amount,
    required this.isNew,
  });

  final int weekNumber;
  final int index;
  final Fertilizer fertilizer;
  final Amount? amount;
  final bool isNew;

  @override
  State<SelectAmountDialog> createState() => _SelectAmountDialogState();
}

class _SelectAmountDialogState extends State<SelectAmountDialog> {
  Unit? _selectedUnit;
  int _selectedQuantity = 0;

  void selectNewUnit(Unit newUnit) {
    setState(() {
      _selectedUnit = newUnit;
    });
  }

  void increaseQuantity() {
    if (_selectedQuantity < maximumQuantity) {
      setState(() {
        _selectedQuantity++;
      });
    }
  }

  void decreaseQuantity() {
    if (_selectedQuantity > 1) {
      setState(() {
        _selectedQuantity--;
      });
    }
  }

  /// create unit widget list
  List<Widget> createUnitWidgets() {
    return Unit.values.map((u) {
      return GestureDetector(
          onTap: () {
            selectNewUnit(u);
          },
          child: UnitWidget(unit: u));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // create fertilizer widget list
    final unitWidgets = createUnitWidgets();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: dialogHorizontalPadding,
        vertical: dialogVerticalPadding,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final availableWidth = min(maxWidth, dialogMaxWidth + 2 * dialogContentPadding);
        final crossAxisCount =
            min((availableWidth / fertilizerWidgetMaxWidth).round(), Unit.values.length);
        final itemWidth = (availableWidth -
                2 * dialogContentPadding -
                (crossAxisCount - 1) * fertilizerWidgetSpacing) /
            crossAxisCount;

        final rowCount = (unitWidgets.length / crossAxisCount).ceil();
        final areaHeight = rowCount * (itemWidth / fertilizerWidgetAspectRatio) +
            (rowCount - 1) * fertilizerWidgetSpacing +
            2 * dialogContentPadding;
        final availableHeight = min(maxHeight, areaHeight);

        return SimpleDialog(
          title: const Text('Choose Amount'),
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: availableWidth / 3,
              width: availableWidth,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      //color: Colors.blue,
                      child: Center(
                        child: FractionallySizedBox(
                          //widthFactor: 0.3,
                          heightFactor: 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  //color: Colors.white,
                                  onPressed: () {
                                    decreaseQuantity();
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: FittedBox(
                                  child: Text(
                                    _selectedQuantity.toString(),
                                    style: const TextStyle(fontSize: 100),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  //color: Colors.white,
                                  onPressed: () {
                                    increaseQuantity();
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.yellow,
                      child: Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          heightFactor: 0.7,
                          child: _selectedUnit == null
                              ? Container(
                                  color: Colors.grey,
                                )
                              : UnitWidget(
                                  unit: _selectedUnit!,
                                ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.orange,
                      child: Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          heightFactor: 0.7,
                          child: FertilizerWidget(
                            fertilizer: widget.fertilizer,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: availableWidth,
              height: availableHeight,
              color: Colors.red,
              child: Align(
                alignment: Alignment.center,
                child: GridView.count(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(dialogContentPadding),
                  childAspectRatio: fertilizerWidgetAspectRatio,
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: fertilizerWidgetSpacing,
                  crossAxisSpacing: fertilizerWidgetSpacing,
                  children: unitWidgets,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              width: availableWidth,
              child: FractionallySizedBox(
                heightFactor: 0.9,
                widthFactor: 0.9,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return IconButton(
                          color: Colors.green,
                          onPressed: _selectedUnit == null || _selectedQuantity == 0
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  final newFertilizerSelection = FertilizerSelection(
                                    fertilizer: widget.fertilizer,
                                    amount: Amount(
                                      unit: _selectedUnit!,
                                      count: _selectedQuantity,
                                    ),
                                  );
                                  widget.isNew
                                      ? ref
                                          .read(fertilizerDataRepositoryProvider.notifier)
                                          .addFertilizerSelection(
                                            weekNumber: widget.weekNumber,
                                            fertilizerSelection: newFertilizerSelection,
                                          )
                                      : ref
                                          .read(fertilizerDataRepositoryProvider.notifier)
                                          .changeFertilizerSelection(
                                            weekNumber: widget.weekNumber,
                                            index: widget.index,
                                            fertilizerSelection: newFertilizerSelection,
                                          );
                                },
                          icon: const Icon(
                            Icons.check_circle_rounded,
                            size: 100,
                          ),
                        );
                      },
                    ),
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
