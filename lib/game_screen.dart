import 'package:agriworx/features/game_mode/data/game_mode_repository.dart';
import 'package:agriworx/features/persons_involved/enumerator/data/enumerator_repository.dart';
import 'package:agriworx/features/persons_involved/presentation/select_user_and_enumerator_screen.dart';
import 'package:agriworx/features/persons_involved/user/data/user_repository.dart';
import 'package:agriworx/features/soil/data/soil_repository.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:agriworx/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants/constants.dart';
import 'constants/week_names.dart';
import 'features/fertilizer/data/fertilizer_data_repository.dart';
import 'features/fertilizer/presentation/fertilizer_selection_widget.dart';
import 'features/game_mode/domain/game_mode.dart';
import 'features/nutrient/data/fold_out_provider.dart';
import 'features/nutrient/domain/nutrient.dart';
import 'features/nutrient/presentation/animated_app_bar.dart';
import 'features/nutrient/presentation/nutrient_bar.dart';
import 'features/result/presentation/save/save_result_button.dart';

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
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameMode = ref.watch(gameModeRepositoryProvider);
    final fertilizerData = ref.watch(fertilizerDataRepositoryProvider);
    final listOfSelectedFertilizers = fertilizerData.listOfSelectedFertilizers;

    final enumerator = ref.watch(enumeratorRepositoryProvider);
    final user = ref.watch(userRepositoryProvider);

    final selectedSoil = ref.watch(soilRepositoryProvider);

    return Scaffold(
      appBar: const AnimatedAppBar(),
      bottomSheet: gameMode == GameMode.experiment
          ? Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              height: 80,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SelectUserAndEnumeratorScreen()),
                          );
                        },
                        child: const Icon(
                          Icons.people,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enumerator: ${enumerator?.firstName} ${enumerator?.lastName}',
                                style: const TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'User: ${user?.firstName} ${user?.lastName}',
                                style: const TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: ColorPalette.practiceModeBottomBar,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              height: 40,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(
                      'Practice Mode',
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: const SaveResultButton(),
      body: Container(
        color: ColorPalette.background,
        child: Center(
          child: Padding(
            padding: EdgeInsets.zero, //const EdgeInsets.only(top: cardsTopPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: screenMaxWidth),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  FractionallySizedBox(
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

                                  final itemList = List.generate(maxNumberOfFertilizersPerWeek,
                                      (fertilizerIndex) {
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
                                                    .watch(
                                                        fertilizerDataRepositoryProvider.notifier)
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
                                                    .watch(
                                                        fertilizerDataRepositoryProvider.notifier)
                                                    .getNutrientInGrams(
                                                      nutrient: Nutrient.phosphorus,
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
                                                    .watch(
                                                        fertilizerDataRepositoryProvider.notifier)
                                                    .getNutrientInGrams(
                                                      nutrient: Nutrient.potassium,
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
                  const Positioned(
                    bottom: 90,
                    right: -10,
                    child: SaveResultButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
