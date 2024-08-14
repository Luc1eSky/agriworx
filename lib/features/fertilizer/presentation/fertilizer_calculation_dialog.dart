import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';

import '../../../constants/constants.dart';
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
        final availableWidth =
            min(maxWidth, dialogMaxWidth + 2 * dialogContentPadding);

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
                          // final selectedFertilizers = availableFertilizers.sublist(0, 3);
                          //
                          // final matrixOfNutrientsOfFertilizers = constructMatrix(
                          //   allowedFertilizers: selectedFertilizers,
                          //   nitrogenInGrams: 0.12,
                          //   phosphorusInGrams: 0.05,
                          //   potassiumInGrams: 0.15,
                          // );
                          //
                          // print(
                          //     '1. matrixOfNutrientsOfFertilizers: $matrixOfNutrientsOfFertilizers');
                          //
                          // applyGaussJordanElimination(matrixOfNutrientsOfFertilizers);
                          //
                          // //print('2. Augmented Matrix: $augmentedMatrix');

                          // 1. Create sub lists
                          getSubsetList(3);

                          // 2. check if Matrix has full rank
                          var M = [
                            [1.0, 2.0, 3.0],
                            [4.0, 5.0, 6.0],
                            [7.0, 8.0, 10.0]
                          ];
                          bool result = hasFullRank(M);
                          print('Matrix M has full rank: $result');
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

/// New version using the latest R code
//
// List<List<double>> performNPKSpaceCalculation({
//   required List<Fertilizer> allowedFertilizers,
//   required double nitrogenInGrams,
//   required double phosphorusInGrams,
//   required double potassiumInGrams,
// }) {
//   const numCards = 3;
// }

List<List<int>> getSubsetList(int n) {
  // Function to generate all non-empty subsets of {1,...,n}
  List<List<int>> subsets = [];

  for (int i = 1; i <= n; i++) {
    subsets.addAll(_combinations(List.generate(n, (index) => index + 1), i));
  }
  print('Subsets: $subsets');
  return subsets;
}

List<List<int>> _combinations(List<int> list, int k) {
  // Helper function to generate combinations of k elements from the list
  List<List<int>> result = [];

  void combine(int start, List<int> current) {
    if (current.length == k) {
      result.add(List.from(current));
      return;
    }

    for (int i = start; i < list.length; i++) {
      current.add(list[i]);
      combine(i + 1, current);
      current.removeLast();
    }
  }

  combine(0, []);
  return result;
}

bool hasFullRank(List<List<double>> M) {
  int rows = M.length;
  int cols = M[0].length;
  int rank = 0;

  // Perform Gaussian elimination
  for (int r = 0; r < rows; r++) {
    bool nonZeroFound = false;

    // Find a non-zero entry in the current column
    for (int c = r; c < cols; c++) {
      if (M[r][c] != 0.0) {
        nonZeroFound = true;

        // Normalize the row
        double divisor = M[r][c];
        for (int k = 0; k < cols; k++) {
          M[r][k] /= divisor;
        }

        // Eliminate all entries below the pivot
        for (int i = r + 1; i < rows; i++) {
          double multiplier = M[i][c];
          for (int k = 0; k < cols; k++) {
            M[i][k] -= M[r][k] * multiplier;
          }
        }

        rank++;
        break;
      }
    }

    if (!nonZeroFound) {
      break;
    }
  }

  return rank == cols;
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

void applyGaussJordanElimination(
    List<List<double>> matrixOfNutrientsOfFertilizers) {
  final equationsCount = matrixOfNutrientsOfFertilizers.length;
  final fertilizerCount = matrixOfNutrientsOfFertilizers.first.length - 1;

  for (int i = 0; i < min(equationsCount, fertilizerCount); i++) {
    // sort row with highest values to top
    int rowIndexWithHighestValue = i;
    for (int otherRowIndex = i + 1;
        otherRowIndex < equationsCount;
        otherRowIndex++) {
      if ((matrixOfNutrientsOfFertilizers[otherRowIndex][i]).abs() >
          (matrixOfNutrientsOfFertilizers[rowIndexWithHighestValue][i]).abs()) {
        rowIndexWithHighestValue = otherRowIndex;
      }
    }

    // swap the pivot row
    final rowWithHighestValue =
        matrixOfNutrientsOfFertilizers[rowIndexWithHighestValue];
    matrixOfNutrientsOfFertilizers[rowIndexWithHighestValue] =
        matrixOfNutrientsOfFertilizers[i];
    matrixOfNutrientsOfFertilizers[i] = rowWithHighestValue;

    // TODO: CHECK IF < 1e-10 IS NEEDED
    if ((matrixOfNutrientsOfFertilizers[i][i]).abs() == 0) {
      continue;
    }

    // Make the diagonal element 1 and eliminate other elements in the column
    final division = matrixOfNutrientsOfFertilizers[i][i];
    for (int columnIndex = 0;
        columnIndex < fertilizerCount + 1;
        columnIndex++) {
      matrixOfNutrientsOfFertilizers[i][columnIndex] /= division;
    }

    // asdsadad
    for (int rowIndex = 0; rowIndex < equationsCount; rowIndex++) {
      if (rowIndex != i) {
        final factor = matrixOfNutrientsOfFertilizers[rowIndex][i];
        for (int columnIndex = 0;
            columnIndex < fertilizerCount + 1;
            columnIndex++) {
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
    final nutrientRow =
        matrixOfNutrientsOfFertilizers[rowIndex].sublist(0, fertilizerCount);
    final targetValue =
        matrixOfNutrientsOfFertilizers[rowIndex][fertilizerCount];

    if (nutrientRow.every((value) => value == 0) && targetValue > 0) {
      hasNoSolution = true;
      return;
    }
  }
}
