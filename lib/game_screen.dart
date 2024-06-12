import 'package:agriworx/features/nutrient/data/fold_out_provider.dart';
import 'package:agriworx/features/nutrient/domain/nutrient.dart';
import 'package:agriworx/features/soil/data/soil_repository.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:agriworx/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/constants.dart';
import 'constants/week_names.dart';
import 'features/fertilizer/data/fertilizer_data_repository.dart';
import 'features/fertilizer/presentation/fertilizer_selection_widget.dart';
import 'features/nutrient/presentation/animated_app_bar.dart';
import 'features/nutrient/presentation/nutrient_bar.dart';

List<Widget> leadingWidgets = weekNames.map((name) {
  return SizedBox(
    width: leadingWidgetWidth,
    child: Text(
      name.toUpperCase(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}).toList();

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(() {
      ref.read(foldOutProvider.notifier).minimizeChart();
      print('Scrolling');
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fertilizerData = ref.watch(fertilizerDataRepositoryProvider);
    final listOfSelectedFertilizers = fertilizerData.listOfSelectedFertilizers;

    final selectedSoil = ref.watch(soilRepositoryProvider);

    return Scaffold(
      appBar: const AnimatedAppBar(),
      body: Container(
        color: ColorPalette.background,
        child: Center(
          child: Padding(
            padding: EdgeInsets.zero, //const EdgeInsets.only(top: cardsTopPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: screenMaxWidth),
              child: FractionallySizedBox(
                widthFactor: cardsVerticalScreenRatio,
                child: Center(
                  child: ListView.builder(
                    controller: controller,
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: itemList,
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
                                            currentNutrientValue: ref
                                                .watch(fertilizerDataRepositoryProvider.notifier)
                                                .getNutrientInGrams(
                                                  nutrient: Nutrient.nitrogen,
                                                  weekNumber: weekIndex,
                                                ),
                                          ),
                                        ),
                                        SizedBox(height: verticalGapHeight),
                                        Expanded(
                                          child: NutrientBar(
                                            nutrient: Nutrient.phosphorus,
                                            barColor: ColorPalette.phosphorusBar,
                                            currentNutrientValue: ref
                                                .watch(fertilizerDataRepositoryProvider.notifier)
                                                .getNutrientInGrams(
                                                  nutrient: Nutrient.nitrogen,
                                                  weekNumber: weekIndex,
                                                ),
                                          ),
                                        ),
                                        SizedBox(height: verticalGapHeight),
                                        Expanded(
                                          child: NutrientBar(
                                            nutrient: Nutrient.potassium,
                                            barColor: ColorPalette.potassiumBar,
                                            currentNutrientValue: ref
                                                .watch(fertilizerDataRepositoryProvider.notifier)
                                                .getNutrientInGrams(
                                                  nutrient: Nutrient.nitrogen,
                                                  weekNumber: weekIndex,
                                                ),
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
