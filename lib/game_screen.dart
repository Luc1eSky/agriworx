import 'package:agriworx/features/nutrient/domain/nutrient.dart';
import 'package:agriworx/features/soil/data/soil_repository.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:agriworx/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/constants.dart';
import 'features/fertilizer/data/fertilizer_data_repository.dart';
import 'features/fertilizer/presentation/fertilizer_selection_widget.dart';
import 'features/nutrient/presentation/nutrient_bar.dart';

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
        color: ColorPalette.background,
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
                        color: ColorPalette.card,
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
                                            barColor: ColorPalette.nitrogenBar,
                                            weekIndex: weekIndex,
                                          ),
                                        ),
                                        SizedBox(height: verticalGapHeight),
                                        Expanded(
                                          child: NutrientBar(
                                            nutrient: Nutrient.phosphorus,
                                            barColor: ColorPalette.phosphorusBar,
                                            weekIndex: weekIndex,
                                          ),
                                        ),
                                        SizedBox(height: verticalGapHeight),
                                        Expanded(
                                          child: NutrientBar(
                                            nutrient: Nutrient.potassium,
                                            barColor: ColorPalette.potassiumBar,
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
