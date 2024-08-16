import 'package:flutter/material.dart';
import 'package:scidart/numdart.dart';

import '../../../../constants/constants.dart';
import '../../data/fertilizer_options.dart';
import '../../domain/fertilizer.dart';

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
                          getSolution(
                            admissibleFertilizers: availableFertilizers.sublist(0, 3),
                            nitrogenInGrams: 20,
                            phosphorusInGrams: 10,
                            potassiumInGrams: 5,
                          );
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
void getSolution({
  required List<Fertilizer> admissibleFertilizers,
  required double nitrogenInGrams,
  required double phosphorusInGrams,
  required double potassiumInGrams,
}) {
  final fertilizerCount = admissibleFertilizers.length;

  final subsetList = getSubsetList(fertilizerCount);
  final subsetListLength = subsetList.length;

  // Initialize X, B, C, and D
  final X = List.generate(subsetListLength, (_) => List.filled(fertilizerCount, 0.0));
  final B = List.generate(subsetListLength, (_) => List.filled(3, 0.0));
  List<double> C = List.filled(subsetListLength, 1e99);
  List<double> D = List.filled(subsetListLength, 1e99);

  print('fertilizerCount: $fertilizerCount');
  print('subsetList: $subsetList');

  // Iterate over subsets
  for (int s = 0; s < subsetListLength; s++) {
    // get subset (fertilizer indices)
    final subset = subsetList[s];

    // create nutrient matrix from fertilizers
    final nitrogenValues = <double>[];
    final phosphorusValues = <double>[];
    final potassiumValues = <double>[];
    for (int fertilizerIndex in subset) {
      final fertilizer = admissibleFertilizers[fertilizerIndex];
      nitrogenValues.add(fertilizer.nitrogenPercentage);
      phosphorusValues.add(fertilizer.phosphorusPercentage);
      potassiumValues.add(fertilizer.potassiumPercentage);
    }

    final matrixA = Array2d([
      Array(nitrogenValues),
      Array(phosphorusValues),
      Array(potassiumValues),
    ]);

    final matrixAQR = QR(matrixA);

    // create target matrix
    var targetMatrix = Array2d([
      Array([nitrogenInGrams]),
      Array([phosphorusInGrams]),
      Array([potassiumInGrams]),
    ]);

    if (matrixAQR.isFullRank()) {
      final solution = matrixAQR.solve(targetMatrix);
      // check if solution has any negative values
      final isValid = solution.every((element) => element.first >= 0);

      if (isValid) {
        // update X, B, C, and D
        // 1. X
        final listSolution = solution.map((array) => array.first).toList();
        for (int i = 0; i < subset.length; i++) {
          final num = subset[i];
          X[s][num] = listSolution[i];
        }
        // 2. B
        final newB = matrixDot(matrixA, solution);
        final listB = newB.map((array) => array.first).toList();
        B[s] = listB;
        // 3. C
        double costForSubset = 0.0;
        for (int i = 0; i < subset.length; i++) {
          final num = subset[i];
          costForSubset += listSolution[i] * admissibleFertilizers[num].pricePerGramInUgx;
        }
        C[s] = costForSubset;
        // 4. D
        final targetList = targetMatrix.map((array) => array.first).toList();
        double sum = 0;
        for (int i = 0; i < listB.length; i++) {
          sum += pow(targetList[i] - listB[i], 2);
        }
        D[s] = sqrt(sum);
      }
    }
  }

  // TODO: NEEDED?
  //D = round(D,7)
  double minDistanceValue = D.reduce((a, b) => a < b ? a : b);
  final minDistanceIndices = D
      .asMap()
      .entries
      .where((entry) => entry.value == minDistanceValue)
      .map((entry) => entry.key)
      .toList();

  double cheapestPrice = double.infinity;
  late int indexOfCheapestSolution;
  for (var minDistanceIndex in minDistanceIndices) {
    final currentPrice = C[minDistanceIndex];
    if (currentPrice < cheapestPrice) {
      cheapestPrice = currentPrice;
      indexOfCheapestSolution = minDistanceIndex;
    }
  }

  print('indexOfCheapestSolution: $indexOfCheapestSolution');
  print('X solution: ${X[indexOfCheapestSolution]}');
  print('B solution: ${B[indexOfCheapestSolution]}');
  print('C solution: ${C[indexOfCheapestSolution]}');
  print('D solution: ${D[indexOfCheapestSolution]}');
}

/// function to generate all non-empty subsets of {1,...,n}
List<List<int>> getSubsetList(int n) {
  List<List<int>> subsets = [];

  for (int i = 0; i <= n; i++) {
    subsets.addAll(_combinations(List.generate(n, (index) => index), i));
  }

  final filteredSubsets =
      subsets.where((set) => set.length <= maxNumberOfFertilizersPerWeek).toList();

  return filteredSubsets;
}

/// helper function to generate combinations of k elements from the list
List<List<int>> _combinations(List<int> list, int k) {
  List<List<int>> result = [];

  void combine(int start, List<int> current) {
    if (current.length == k) {
      if (current.isNotEmpty) {
        result.add(List.from(current));
      }
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
