import 'package:agriworx/features/nutrient/domain/nutrient.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class SelectNpkLevelsDialog extends StatefulWidget {
  const SelectNpkLevelsDialog({
    required this.weekNumber,
    super.key,
  });

  final int weekNumber;

  @override
  State<SelectNpkLevelsDialog> createState() => _SelectNpkLevelsDialogState();
}

class _SelectNpkLevelsDialogState extends State<SelectNpkLevelsDialog> {
  double _selectedNitrogen = 0.0;
  double _selectedPhosporus = 0.0;
  double _selectedPotassium = 0.0;

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
    return SimpleDialog(
      title: const Text('Select NPK Levels'),
      contentPadding: const EdgeInsets.all(16),
      insetPadding: const EdgeInsets.all(60),
      children: [
        SizedBox(
          width: 800,
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
                      onPressed: () {},
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
        ),
      ],
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
