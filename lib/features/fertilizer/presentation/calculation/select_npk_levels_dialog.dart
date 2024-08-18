import 'package:agriworx/features/nutrient/domain/nutrient.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/small_dialog.dart';
import '../../../../constants/constants.dart';
import 'fertilizer_calculation_dialog.dart';

class SelectNpkLevelsDialog extends StatefulWidget {
  const SelectNpkLevelsDialog({
    required this.weekNumber,
    super.key,
    this.selectedNitrogen = 0.0,
    this.selectedPhosporus = 0.0,
    this.selectedPotassium = 0.0,
  });

  final int weekNumber;
  final double selectedNitrogen;
  final double selectedPhosporus;
  final double selectedPotassium;

  @override
  State<SelectNpkLevelsDialog> createState() => _SelectNpkLevelsDialogState();
}

class _SelectNpkLevelsDialogState extends State<SelectNpkLevelsDialog> {
  late double _selectedNitrogen = widget.selectedNitrogen;
  late double _selectedPhosporus = widget.selectedPhosporus;
  late double _selectedPotassium = widget.selectedPotassium;

  Function(double) getNutrientFunction(Nutrient nutrient) {
    return (double value) {
      setState(() {
        switch (nutrient) {
          case Nutrient.nitrogen:
            _selectedNitrogen = value;
            break;
          case Nutrient.phosphorus:
            _selectedPhosporus = value;
            break;
          case Nutrient.potassium:
            _selectedPotassium = value;
            break;
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return SmallDialog(
      title: 'Select NPK Levels',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NutrientSlider(
              nutrientValue: _selectedNitrogen,
              nutrient: Nutrient.nitrogen,
              onChangedCallback: getNutrientFunction(Nutrient.nitrogen),
            ),
            const SizedBox(height: 20),
            NutrientSlider(
              nutrientValue: _selectedPhosporus,
              nutrient: Nutrient.phosphorus,
              onChangedCallback: getNutrientFunction(Nutrient.phosphorus),
            ),
            const SizedBox(height: 20),
            NutrientSlider(
              nutrientValue: _selectedPotassium,
              nutrient: Nutrient.potassium,
              onChangedCallback: getNutrientFunction(Nutrient.potassium),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    // do nothing if all values are 0
                    if (_selectedNitrogen == 0.0 &&
                        _selectedPhosporus == 0.0 &&
                        _selectedPotassium == 0) {
                      return;
                    }

                    // otherwise move to next dialog
                    Navigator.of(context).pop();

                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => FertilizerCalculationDialog(
                        weekNumber: widget.weekNumber,
                        nitrogenInGrams: _selectedNitrogen,
                        phosphorusInGrams: _selectedPhosporus,
                        potassiumInGrams: _selectedPotassium,
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Ok'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NutrientSlider extends StatelessWidget {
  const NutrientSlider({
    super.key,
    required this.nutrientValue,
    required this.nutrient,
    required this.onChangedCallback,
  });

  final double nutrientValue;
  final Nutrient nutrient;
  final Function(double) onChangedCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${nutrient.symbol}: ${nutrientValue.toStringAsFixed(1)}g',
          style: const TextStyle(fontSize: 20),
        ),
        Slider(
          value: nutrientValue,
          max: maxNutrientValueAllFertilizers,
          activeColor: nutrient.color,
          inactiveColor: Colors.grey,
          divisions: (maxNutrientValueAllFertilizers / 0.1).round(),
          onChanged: onChangedCallback,
        ),
      ],
    );
  }
}
