import 'package:agriworx/features/fertilizer/domain/nutrient.dart';
import 'package:agriworx/features/soil/data/soil_repository.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:agriworx/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/constants.dart';
import 'features/fertilizer/data/fertilizer_data_repository.dart';
import 'features/fertilizer/presentation/fertilizer_selection_widget.dart';

List<Widget> leadingWidgets = List.generate(numberOfWeeks, (index) {
  return SizedBox(
    width: leadingWidgetWidth,
    child: Text(
      index == 0
          ? 'PRE'
          : index == 1
              ? 'TRANS'
              : 'WEEK ${(index - 1).toString()}',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
});

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fertilizerData = ref.watch(fertilizerDataRepositoryProvider);
    final listOfSelectedFertilizers = fertilizerData.listOfSelectedFertilizers;

    final selectedSoil = ref.watch(soilRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agriworks Test Version / soil: ${selectedSoil?.name}'),
      ),
      body: Container(
        color: ColorPalette().background,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: cardsTopPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: screenMaxWidth),
              child: FractionallySizedBox(
                widthFactor: cardsVerticalScreenRatio,
                child: Center(
                  child: ListView.builder(
                    itemCount: numberOfWeeks,
                    itemBuilder: (context, weekIndex) {
                      final weekList = listOfSelectedFertilizers[weekIndex];
                      return Card(
                        color: ColorPalette().card,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: cardContentPadding),
                          minVerticalPadding: cardContentPadding,
                          subtitle: LayoutBuilder(
                            builder: (context, constraints) {
                              final maxWidth = constraints.maxWidth;
                              final fertilizerMaxWidth = maxWidth - leadingWidgetWidth;

                              final verticalGapHeight =
                                  verticalGapRatio * getItemWidth(fertilizerMaxWidth);

                              final itemList =
                                  List.generate(maxNumberOfFertilizersPerWeek, (fertilizerIndex) {
                                return FertilizerSelectionWidget(
                                  maxWidth: fertilizerMaxWidth,
                                  weekIndex: weekIndex,
                                  fertilizerIndex: fertilizerIndex,
                                  fertilizerSelection:
                                      weekList.isNotEmpty && fertilizerIndex < weekList.length
                                          ? weekList[fertilizerIndex]
                                          : null,
                                );
                              });
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      leadingWidgets[weekIndex],
                                      Expanded(
                                        child: Container(
                                          //color: Colors.orange,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: itemList,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2 * verticalGapHeight),
                                  AspectRatio(
                                    aspectRatio: 5.0,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: NutrientBar(
                                            nutrient: Nutrient.nitrogen,
                                            barColor: Colors.lightBlueAccent,
                                            weekIndex: weekIndex,
                                          ),
                                        ),
                                        SizedBox(height: verticalGapHeight),
                                        Expanded(
                                          child: NutrientBar(
                                            nutrient: Nutrient.phosphorus,
                                            barColor: Colors.purple,
                                            weekIndex: weekIndex,
                                          ),
                                        ),
                                        SizedBox(height: verticalGapHeight),
                                        Expanded(
                                          child: NutrientBar(
                                            nutrient: Nutrient.potassium,
                                            barColor: Colors.yellow,
                                            weekIndex: weekIndex,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NutrientBar extends ConsumerWidget {
  const NutrientBar({
    required this.nutrient,
    required this.barColor,
    required this.weekIndex,
    this.maxValue = maxValueAllFertilizers,
    super.key,
  });

  final Nutrient nutrient;
  final Color barColor;
  final int weekIndex;
  final double maxValue;

  //final double idealValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentNutrientValue = ref
        .watch(fertilizerDataRepositoryProvider.notifier)
        .getNutrientInGrams(nutrient: nutrient, weekNumber: weekIndex);

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
            color: barColor,
            child: Center(
              child: Text(currentNutrientValue.toString()),
            ),
          ),
        ),
      ],
    );
  }
}
//
// class FertilizerSelectionWidget extends StatelessWidget {
//   const FertilizerSelectionWidget({
//     super.key,
//     required this.itemWidth,
//     required this.aspectRatio,
//     required this.weekIndex,
//     required this.fertilizerIndex,
//     this.fertilizerSelection,
//   });
//
//   final double itemWidth;
//   final double aspectRatio;
//   final int weekIndex;
//   final int fertilizerIndex;
//   final FertilizerSelection? fertilizerSelection;
//
//   @override
//   Widget build(BuildContext context) {
//     final fertilizer = fertilizerSelection?.fertilizer;
//     return GestureDetector(
//       onTap: () {
//         print('weekIndex: $weekIndex, fertilizerIndex: $fertilizerIndex');
//       },
//       child: SizedBox(
//         width: itemWidth,
//         child: AspectRatio(
//           aspectRatio: aspectRatio,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AspectRatio(
//                 aspectRatio: 1.0,
//                 child: Container(
//                   color: fertilizer == null ? Colors.grey : fertilizer.color,
//                   child: Text('test'),
//                 ),
//               ),
//               Container(
//                 height: quantityFieldHeightRatio * itemWidth,
//                 color: fertilizerSelection == null ? Colors.grey : Colors.green,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
