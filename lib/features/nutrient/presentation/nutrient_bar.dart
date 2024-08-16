import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../style/color_palette.dart';
import '../domain/nutrient.dart';

class NutrientBar extends StatelessWidget {
  const NutrientBar({
    required this.nutrient,
    required this.barColor,
    required this.currentNutrientValue,
    this.maxValue = maxNutrientValueAllFertilizers,
    super.key,
  });

  final Nutrient nutrient;
  final Color barColor;
  final double currentNutrientValue;
  final double maxValue;

  //final double idealValue;

  @override
  Widget build(BuildContext context) {
    // return % nutrient value of max limited to max
    final currentPercentage = currentNutrientValue / maxValue;
    final nutrientExceedsLimit = currentPercentage > 1;
    final currentPercentageLimited = min(currentPercentage, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 25,
          child: FittedBox(
            child: Text(
              nutrient.symbol,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ColorPalette.barBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(builder: (context, constraints) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  width: constraints.maxWidth * currentPercentageLimited,
                  decoration: BoxDecoration(
                    color: nutrientExceedsLimit ? Colors.red : barColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),

            // Center(
            //   child: Text(currentNutrientValue.toString()),
            // ),
          ),
        ),
        SizedBox(
          width: 40,
          child: FittedBox(
            child: Text(
              '${maxValue}g',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
