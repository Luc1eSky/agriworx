import 'package:agriworx/common_widgets/small_dialog.dart';
import 'package:agriworx/features/fertilizer/presentation/calculation/fertilizer_calculation_dialog_controller.dart';
import 'package:agriworx/features/fertilizer/presentation/calculation/select_npk_levels_dialog.dart';
import 'package:agriworx/features/fertilizer/presentation/calculation/show_fertilizer_recommendation_dialog.dart';
import 'package:agriworx/features/fertilizer/presentation/fertilizer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constants.dart';
import '../../data/fertilizer_options.dart';
import '../../domain/fertilizer.dart';

class FertilizerCalculationDialog extends ConsumerStatefulWidget {
  const FertilizerCalculationDialog(
      {super.key,
      required this.weekNumber,
      required this.nitrogenInGrams,
      required this.phosphorusInGrams,
      required this.potassiumInGrams});

  final int weekNumber;
  final double nitrogenInGrams;
  final double phosphorusInGrams;
  final double potassiumInGrams;

  @override
  ConsumerState<FertilizerCalculationDialog> createState() =>
      _FertilizerCalculationDialogState();
}

class _FertilizerCalculationDialogState
    extends ConsumerState<FertilizerCalculationDialog> {
  List<bool> _fertilizerIsSelectedList =
      List.generate(availableFertilizers.length, (index) => false);

  void toggleSelection(int index) {
    setState(() =>
        _fertilizerIsSelectedList[index] = !_fertilizerIsSelectedList[index]);
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(fertilizerCalculationDialogControllerProvider);

    return SmallDialog(
      title: 'Select Fertilizers',
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: asyncState.isLoading
                    ? const Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Calculating your fertilizers.')
                        ],
                      ))
                    : GridView(
                        padding: const EdgeInsets.all(dialogContentPadding),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        children: availableFertilizers
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  toggleSelection(entry.key);
                                },
                                child: FertilizerWidget(
                                  fertilizer: entry.value,
                                  isGreyedOut:
                                      !_fertilizerIsSelectedList[entry.key],
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: asyncState.isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SelectNpkLevelsDialog(
                                      weekNumber: widget.weekNumber,
                                      selectedNitrogen: widget.nitrogenInGrams,
                                      selectedPhosporus:
                                          widget.phosphorusInGrams,
                                      selectedPotassium:
                                          widget.potassiumInGrams,
                                    );
                                  });
                            },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text('Back'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: asyncState.isLoading
                          ? null
                          : () async {
                              if (_fertilizerIsSelectedList
                                  .any((value) => value == true)) {
                                List<Fertilizer> selectedFertilizers = [];
                                for (var i = 0;
                                    i < _fertilizerIsSelectedList.length;
                                    i++) {
                                  if (_fertilizerIsSelectedList[i] == true) {
                                    selectedFertilizers
                                        .add(availableFertilizers[i]);
                                  }
                                }

                                final fertilizerSelections = await ref
                                    .read(
                                        fertilizerCalculationDialogControllerProvider
                                            .notifier)
                                    .getSolution(
                                      admissibleFertilizers:
                                          selectedFertilizers,
                                      nitrogenInGrams: widget.nitrogenInGrams,
                                      phosphorusInGrams:
                                          widget.phosphorusInGrams,
                                      potassiumInGrams: widget.potassiumInGrams,
                                    );

                                if (fertilizerSelections == null ||
                                    !context.mounted) {
                                  return;
                                }

                                // otherwise move to next dialog
                                Navigator.of(context).pop();

                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) =>
                                      ShowFertilizerRecommendationDialog(
                                    weekNumber: widget.weekNumber,
                                    fertilizerRecommendation:
                                        fertilizerSelections,
                                    nitrogenInGramsTarget:
                                        widget.nitrogenInGrams,
                                    phosphorusInGramsTarget:
                                        widget.phosphorusInGrams,
                                    potassiumInGramsTarget:
                                        widget.potassiumInGrams,
                                  ),
                                );

                                //ShowFertilizerRecommendationDialog()
                              }
                            },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text('Ok'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// /// New version using the latest R code
// List<FertilizerSelection> getSolution({
//   required List<Fertilizer> admissibleFertilizers,
//   required double nitrogenInGrams,
//   required double phosphorusInGrams,
//   required double potassiumInGrams,
// }) {
//   final fertilizerCount = admissibleFertilizers.length;
//
//   final subsetList = getSubsetList(fertilizerCount);
//   final subsetListLength = subsetList.length;
//
//   // Initialize X, B, C, and D
//   final X = List.generate(subsetListLength, (_) => List.filled(fertilizerCount, 0.0));
//   final B = List.generate(subsetListLength, (_) => List.filled(3, 0.0));
//   List<double> C = List.filled(subsetListLength, 1e99);
//   List<double> D = List.filled(subsetListLength, 1e99);
//
//   // print('fertilizerCount: $fertilizerCount');
//   // print('subsetList: $subsetList');
//
//   // Iterate over subsets
//   for (int s = 0; s < subsetListLength; s++) {
//     // get subset (fertilizer indices)
//     final subset = subsetList[s];
//
//     // create nutrient matrix from fertilizers
//     final nitrogenValues = <double>[];
//     final phosphorusValues = <double>[];
//     final potassiumValues = <double>[];
//     for (int fertilizerIndex in subset) {
//       final fertilizer = admissibleFertilizers[fertilizerIndex];
//       nitrogenValues.add(fertilizer.nitrogenPercentage);
//       phosphorusValues.add(fertilizer.phosphorusPercentage);
//       potassiumValues.add(fertilizer.potassiumPercentage);
//     }
//
//     final matrixA = Array2d([
//       Array(nitrogenValues),
//       Array(phosphorusValues),
//       Array(potassiumValues),
//     ]);
//
//     final matrixAQR = QR(matrixA);
//
//     // create target matrix
//     var targetMatrix = Array2d([
//       Array([nitrogenInGrams]),
//       Array([phosphorusInGrams]),
//       Array([potassiumInGrams]),
//     ]);
//
//     if (matrixAQR.isFullRank()) {
//       final solution = matrixAQR.solve(targetMatrix);
//       // check if solution has any negative values
//       final isValid = solution.every((element) => element.first >= 0);
//
//       if (isValid) {
//         // update X, B, C, and D
//         // 1. X
//         final listSolution = solution.map((array) => array.first).toList();
//         for (int i = 0; i < subset.length; i++) {
//           final num = subset[i];
//           X[s][num] = listSolution[i];
//         }
//         // 2. B
//         final newB = matrixDot(matrixA, solution);
//         final listB = newB.map((array) => array.first).toList();
//         B[s] = listB;
//         // 3. C
//         double costForSubset = 0.0;
//         for (int i = 0; i < subset.length; i++) {
//           final num = subset[i];
//           costForSubset += listSolution[i] * admissibleFertilizers[num].pricePerGramInUgx;
//         }
//         C[s] = costForSubset;
//         // 4. D
//         final targetList = targetMatrix.map((array) => array.first).toList();
//         double sum = 0;
//         for (int i = 0; i < listB.length; i++) {
//           sum += pow(targetList[i] - listB[i], 2);
//         }
//         D[s] = sqrt(sum);
//       }
//     }
//   }
//
//   // TODO: NEEDED?
//   //D = round(D,7)
//   double minDistanceValue = D.reduce((a, b) => a < b ? a : b);
//   final minDistanceIndices = D
//       .asMap()
//       .entries
//       .where((entry) => entry.value == minDistanceValue)
//       .map((entry) => entry.key)
//       .toList();
//
//   double cheapestPrice = double.infinity;
//   late int indexOfCheapestSolution;
//   for (var minDistanceIndex in minDistanceIndices) {
//     final currentPrice = C[minDistanceIndex];
//     if (currentPrice < cheapestPrice) {
//       cheapestPrice = currentPrice;
//       indexOfCheapestSolution = minDistanceIndex;
//     }
//   }
//
//   // print('indexOfCheapestSolution: $indexOfCheapestSolution');
//   // print('X solution: ${X[indexOfCheapestSolution]}');
//   // print('B solution: ${B[indexOfCheapestSolution]}');
//   // print('C solution: ${C[indexOfCheapestSolution]}');
//   // print('D solution: ${D[indexOfCheapestSolution]}');
//
//   final solution = X[indexOfCheapestSolution];
//
//   List<FertilizerSelection> solutionFertilizerSelections = [];
//   for (int i = 0; i < solution.length; i++) {
//     if (solution[i] > 0) {
//       solutionFertilizerSelections.add(
//         FertilizerSelection(
//           fertilizer: admissibleFertilizers[i],
//           amount: Amount(count: solution[i], unit: Unit.grams),
//         ),
//       );
//     }
//   }
//
//   return solutionFertilizerSelections;
// }
