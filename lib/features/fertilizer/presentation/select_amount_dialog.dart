import 'package:agriworx/common_widgets/default_dialog.dart';
import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:agriworx/features/fertilizer/presentation/fertilizer_widget.dart';
import 'package:agriworx/features/fertilizer/presentation/unit_widget.dart';
import 'package:agriworx/features/nutrient/presentation/nutrient_bar.dart';
import 'package:agriworx/features/persons_involved/user/data/user_repository.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';
import '../../nutrient/domain/nutrient.dart';
import '../domain/amount.dart';
import '../domain/fertilizer.dart';
import '../domain/unit.dart';

String convertNumber(double number) {
  String formattedNumber = NumberFormat('0.0').format(number);
  int spacesNeeded = 3 - formattedNumber.split('.')[0].length;
  return spacesNeeded > 0
      ? ' ' * spacesNeeded + formattedNumber
      : formattedNumber;
}

class SelectAmountDialog extends ConsumerStatefulWidget {
  const SelectAmountDialog({
    super.key,
    required this.fertilizer,
    required this.weekNumber,
    required this.index,
    required this.amount,
  });

  final Fertilizer fertilizer;
  final Amount? amount;
  final int weekNumber;
  final int index;

  @override
  ConsumerState<SelectAmountDialog> createState() =>
      _SelectAmountDialog2State();
}

class _SelectAmountDialog2State extends ConsumerState<SelectAmountDialog> {
  Unit? _selectedUnit;
  late double _selectedQuantity;
  FertilizerSelection? _currentFertilizerSelection;

  @override
  void initState() {
    super.initState();
    _selectedQuantity = widget.amount?.count ?? 0.0;
    _selectedUnit = widget.amount?.unit;
    _updateFertilizerSelection();
  }

  void _updateFertilizerSelection() {
    if (_selectedUnit != null) {
      _currentFertilizerSelection = FertilizerSelection(
        fertilizer: widget.fertilizer,
        amount: Amount(
          count: _selectedQuantity,
          unit: _selectedUnit!,
        ),
        selectionWasCalculated: false,
      );
    }
  }

  void selectNewUnit(Unit newUnit) {
    if (newUnit == _selectedUnit) {
      return;
    }
    if (newUnit == Unit.grams || _selectedUnit == Unit.grams) {
      // reset amount to 0
      _selectedQuantity = 0;
    }

    setState(() {
      _selectedUnit = newUnit;
      _updateFertilizerSelection();
    });
  }

  void increaseQuantity() {
    if (_selectedQuantity < maximumQuantity) {
      setState(() {
        _selectedQuantity += 0.5;
        _updateFertilizerSelection();
      });
    }
  }

  void decreaseQuantity() {
    if (_selectedQuantity >= 0.5) {
      setState(() {
        _selectedQuantity -= 0.5;
        _updateFertilizerSelection();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userRepositoryProvider);
    return DefaultDialog(
      hasCloseButton: false,
      title: 'Choose Amount',
      child: LayoutBuilder(builder: (context, constraints) {
        final contentWidth = constraints.maxWidth;

        return Column(
          children: [
            SizedBox(
              height: contentWidth / 3,
              width: contentWidth,
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Expanded(
                            child: _selectedUnit == Unit.grams
                                ? const SizedBox()
                                : AmountButtonWidget(
                                    iconData: Icons.add,
                                    onTapFunction: increaseQuantity,
                                  ),
                          ),
                          Expanded(
                            child: FittedBox(
                              child: Text(
                                _selectedQuantity.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 100),
                              ),
                            ),
                          ),
                          Expanded(
                            child: _selectedUnit == Unit.grams
                                ? const SizedBox()
                                : AmountButtonWidget(
                                    iconData: Icons.remove,
                                    onTapFunction: decreaseQuantity,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AspectRatio(
                    aspectRatio: amountWidgetAspectRatio,
                    child: _selectedUnit == null
                        ? Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.question_mark,
                                  size: 42,
                                ),
                              ),
                            ),
                          )
                        : UnitWidget(unit: _selectedUnit!),
                  ),
                  const SizedBox(width: 12),
                  FertilizerWidget(fertilizer: widget.fertilizer),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: _currentFertilizerSelection == null
                          ? null
                          : FittedBox(
                              child: Text(
                                '${convertNumber(_currentFertilizerSelection!.getFertilizerInGrams())}g',
                                //style: const TextStyle(fontSize: 50),
                                style: const TextStyle(
                                  fontSize: 50,
                                ), // Ensures consistent width for digits
                              ),
                            ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_selectedUnit == Unit.grams)
              Slider(
                value: _selectedQuantity,
                max: 50,
                inactiveColor: Colors.grey,
                divisions: (50 / 0.1).round(),
                onChanged: (double value) {
                  setState(() {
                    _selectedQuantity = value;
                    _updateFertilizerSelection();
                  });
                },
              ),
            SizedBox(
              height: contentWidth / 3,
              width: contentWidth,
              child: Row(
                children: [
                  Expanded(
                    child: SelectableUnitWidget(
                      unit: Unit.glassBottlecap,
                      onTapFunction: selectNewUnit,
                    ),
                  ),
                  Expanded(
                    child: SelectableUnitWidget(
                      unit: Unit.blueBottlecap,
                      onTapFunction: selectNewUnit,
                    ),
                  ),
                  Expanded(
                    child: SelectableUnitWidget(
                      unit: Unit.grams,
                      onTapFunction: selectNewUnit,
                    ),
                  ),
                  if (widget.fertilizer.name == 'MANURE')
                    Expanded(
                      child: SelectableUnitWidget(
                        unit: Unit.tampeco,
                        onTapFunction: selectNewUnit,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (currentUser?.group.id != 0)
              SizedBox(
                height: 70,
                width: contentWidth,
                child: Column(
                  children: [
                    Expanded(
                      child: NutrientBar(
                        nutrient: Nutrient.nitrogen,
                        barColor: ColorPalette.nitrogenBar,
                        currentNutrientValue: _currentFertilizerSelection
                                ?.getNutrientInGrams(Nutrient.nitrogen) ??
                            0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: NutrientBar(
                        nutrient: Nutrient.phosphorus,
                        barColor: ColorPalette.phosphorusBar,
                        currentNutrientValue: _currentFertilizerSelection
                                ?.getNutrientInGrams(Nutrient.phosphorus) ??
                            0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: NutrientBar(
                        nutrient: Nutrient.potassium,
                        barColor: ColorPalette.potassiumBar,
                        currentNutrientValue: _currentFertilizerSelection
                                ?.getNutrientInGrams(Nutrient.potassium) ??
                            0,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.check_circle,
                  size: 56,
                  color: _selectedQuantity == 0 || _selectedUnit == null
                      ? Colors.grey
                      : Colors.green,
                ),
                onPressed: _selectedQuantity == 0 || _selectedUnit == null
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ref
                            .read(fertilizerDataRepositoryProvider.notifier)
                            .changeOrAddFertilizerSelection(
                              weekNumber: widget.weekNumber,
                              index: widget.index,
                              fertilizerSelection: _currentFertilizerSelection!,
                            );
                      },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class AmountButtonWidget extends StatelessWidget {
  const AmountButtonWidget({
    super.key,
    required this.iconData,
    required this.onTapFunction,
  });

  final IconData iconData;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorPalette.amountButtonBackground,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(iconData),
        onPressed: () {
          onTapFunction();
        },
      ),
    );
  }
}

class SelectableUnitWidget extends StatelessWidget {
  const SelectableUnitWidget({
    super.key,
    required this.unit,
    required this.onTapFunction,
  });

  final Unit unit;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapFunction(unit);
      },
      child: UnitWidget(unit: unit),
    );
  }
}
