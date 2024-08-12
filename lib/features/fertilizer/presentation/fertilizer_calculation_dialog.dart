import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../data/fertilizer_options.dart';
import '../domain/fertilizer.dart';

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
                        onPressed: () {
                          final selectedFertilizers = availableFertilizers.sublist(0, 3);

                          final matrixOfNutrientsOfFertilizers = constructMatrix(
                            allowedFertilizers: selectedFertilizers,
                            nitrogenInGrams: 0.12,
                            phosphorusInGrams: 0.05,
                            potassiumInGrams: 0.15,
                          );

                          print(
                              '1. matrixOfNutrientsOfFertilizers: $matrixOfNutrientsOfFertilizers');

                          applyGaussJordanElimination(matrixOfNutrientsOfFertilizers);

                          //print('2. Augmented Matrix: $augmentedMatrix');
                        },
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

List<List<double>> constructMatrix({
  required List<Fertilizer> allowedFertilizers,
  required double nitrogenInGrams,
  required double phosphorusInGrams,
  required double potassiumInGrams,
}) {
  List<double> nitrogenPercentages = [];
  List<double> phosphorusPercentages = [];
  List<double> potassiumPercentages = [];

  for (Fertilizer fertilizer in allowedFertilizers) {
    nitrogenPercentages.add(fertilizer.nitrogenPercentage);
    phosphorusPercentages.add(fertilizer.phosphorusPercentage);
    potassiumPercentages.add(fertilizer.potassiumPercentage);
  }

  nitrogenPercentages.add(nitrogenInGrams);
  phosphorusPercentages.add(phosphorusInGrams);
  potassiumPercentages.add(potassiumInGrams);

  List<List<double>> matrixOfNutrientsOfFertilizers = [
    nitrogenPercentages,
    phosphorusPercentages,
    potassiumPercentages,
  ];

  return matrixOfNutrientsOfFertilizers;
}

void applyGaussJordanElimination(List<List<double>> matrixOfNutrientsOfFertilizers) {
  final equationsCount = matrixOfNutrientsOfFertilizers.length;
  final fertilizerCount = matrixOfNutrientsOfFertilizers.first.length - 1;

  for (int i = 0; i < min(equationsCount, fertilizerCount); i++) {
    // sort row with highest values to top
    int rowIndexWithHighestValue = i;
    for (int otherRowIndex = i + 1; otherRowIndex < equationsCount; otherRowIndex++) {
      if ((matrixOfNutrientsOfFertilizers[otherRowIndex][i]).abs() >
          (matrixOfNutrientsOfFertilizers[rowIndexWithHighestValue][i]).abs()) {
        rowIndexWithHighestValue = otherRowIndex;
      }
    }

    // swap the pivot row
    final rowWithHighestValue = matrixOfNutrientsOfFertilizers[rowIndexWithHighestValue];
    matrixOfNutrientsOfFertilizers[rowIndexWithHighestValue] = matrixOfNutrientsOfFertilizers[i];
    matrixOfNutrientsOfFertilizers[i] = rowWithHighestValue;

    // TODO: CHECK IF < 1e-10 IS NEEDED
    if ((matrixOfNutrientsOfFertilizers[i][i]).abs() == 0) {
      continue;
    }

    // Make the diagonal element 1 and eliminate other elements in the column
    final division = matrixOfNutrientsOfFertilizers[i][i];
    for (int columnIndex = 0; columnIndex < fertilizerCount + 1; columnIndex++) {
      matrixOfNutrientsOfFertilizers[i][columnIndex] /= division;
    }

    // asdsadad
    for (int rowIndex = 0; rowIndex < equationsCount; rowIndex++) {
      if (rowIndex != i) {
        final factor = matrixOfNutrientsOfFertilizers[rowIndex][i];
        for (int columnIndex = 0; columnIndex < fertilizerCount + 1; columnIndex++) {
          matrixOfNutrientsOfFertilizers[rowIndex][columnIndex] -=
              factor * matrixOfNutrientsOfFertilizers[i][columnIndex];
        }
      }
    }
  }

  print('Gauss Jordan STEP 1: $matrixOfNutrientsOfFertilizers');

  bool hasNoSolution = false;
  bool hasInfiniteSolutions = false;

  // check if one nutrient has no contributing fertilizers, but is required
  for (int rowIndex = 0; rowIndex < equationsCount; rowIndex++) {
    final nutrientRow = matrixOfNutrientsOfFertilizers[rowIndex].sublist(0, fertilizerCount);
    final targetValue = matrixOfNutrientsOfFertilizers[rowIndex][fertilizerCount];

    if (nutrientRow.every((value) => value == 0) && targetValue > 0) {
      hasNoSolution = true;
      return;
    }
  }
}
