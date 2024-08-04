import 'package:agriworx/constants/week_names.dart';
import 'package:agriworx/features/game_mode/presentation/game_mode_selection_screen.dart';
import 'package:agriworx/features/nutrient/data/fold_out_provider.dart';
import 'package:agriworx/features/nutrient/domain/nutrient.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/constants.dart';
import '../../fertilizer/data/fertilizer_data_repository.dart';
import '../../game_mode/data/game_mode_repository.dart';

class ChartData {
  ChartData(this.x, this.y1, this.y2, this.y3);
  final String x;
  final double y1;
  final double y2;
  final double y3;
}

class AnimatedAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const AnimatedAppBar({super.key});

  @override
  ConsumerState<AnimatedAppBar> createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(500.0);
}

class _AnimatedAppBarState extends ConsumerState<AnimatedAppBar> {
  @override
  Widget build(BuildContext context) {
    final gameMode = ref.watch(gameModeRepositoryProvider);

    final fertilizerData = ref.watch(fertilizerDataRepositoryProvider);
    final hasSelectedFertilizer =
        fertilizerData.listOfWeeklyFertilizerSelections.any((e) => e.selections.isNotEmpty);

    final isFoldedOut = ref.watch(foldOutProvider);

    final List<ChartData> chartData = [
      for (int i = 0; i < weekNames.length; i += 1)
        ChartData(
          i <= 1 ? weekNames[i] : (i - 1).toString(),
          ref.read(fertilizerDataRepositoryProvider.notifier).getNutrientInGrams(
                nutrient: Nutrient.nitrogen,
                weekNumber: i,
              ),
          ref.read(fertilizerDataRepositoryProvider.notifier).getNutrientInGrams(
                nutrient: Nutrient.phosphorus,
                weekNumber: i,
              ),
          ref.read(fertilizerDataRepositoryProvider.notifier).getNutrientInGrams(
                nutrient: Nutrient.potassium,
                weekNumber: i,
              ),
        )
    ];

    return Material(
      elevation: 10.0,
      color: Colors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (hasSelectedFertilizer) {
              ref.read(foldOutProvider.notifier).toggleState();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            onEnd: () => setState(() {}),
            height: hasSelectedFertilizer
                ? isFoldedOut
                    ? 360
                    : 140
                : 50,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //gameMode == GameMode.experiment ? const LoadResultButton() : const
                      //SizedBox(),
                      const FittedBox(
                        child: Text(
                          'Agriworks Test Version',
                          style: TextStyle(fontSize: 100),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const GameModeSelectionScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 10),
                if (hasSelectedFertilizer)
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: screenMaxWidth * 1.5),
                      child: FractionallySizedBox(
                        widthFactor: cardsVerticalScreenRatio,
                        child: SfCartesianChart(
                          // only show axis title when folded out
                          primaryXAxis: isFoldedOut
                              ? const CategoryAxis(
                                  title: AxisTitle(text: 'week'),
                                )
                              : const CategoryAxis(),
                          primaryYAxis: isFoldedOut
                              ? const NumericAxis(
                                  rangePadding: ChartRangePadding.auto,
                                  title: AxisTitle(text: 'grams'),
                                )
                              : const NumericAxis(
                                  rangePadding: ChartRangePadding.auto,
                                ),
                          legend: Legend(
                            isVisible: isFoldedOut,
                            position: LegendPosition.right,
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            legendItemBuilder: (name, chartSeries, __, ___) => SizedBox(
                              width: 60,
                              height: 30,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: chartSeries?.color ?? Colors.transparent,
                                    ),
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      child: Text('$name'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          series: [
                            ColumnSeries<ChartData, String>(
                              name: 'N',
                              animationDuration: 100,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y1,
                              color: ColorPalette.nitrogenBar,
                            ),
                            ColumnSeries<ChartData, String>(
                              name: 'P',
                              animationDuration: 100,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y2,
                              color: ColorPalette.phosphorusBar,
                            ),

                            ColumnSeries<ChartData, String>(
                              name: 'K',
                              animationDuration: 100,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y3,
                              color: ColorPalette.potassiumBar,
                            ),
                            // StackedColumnSeries<ChartData, String>(
                            //   name: 'N',
                            //   animationDuration: 100,
                            //   dataSource: chartData,
                            //   xValueMapper: (ChartData data, _) => data.x,
                            //   yValueMapper: (ChartData data, _) => data.y1,
                            //   color: ColorPalette.nitrogenBar,
                            // ),
                            // StackedColumnSeries<ChartData, String>(
                            //   name: 'P',
                            //   animationDuration: 100,
                            //   dataSource: chartData,
                            //   xValueMapper: (ChartData data, _) => data.x,
                            //   yValueMapper: (ChartData data, _) => data.y2,
                            //   color: ColorPalette.phosphorusBar,
                            // ),
                            // StackedColumnSeries<ChartData, String>(
                            //   name: 'K',
                            //   animationDuration: 100,
                            //   dataSource: chartData,
                            //   xValueMapper: (ChartData data, _) => data.x,
                            //   yValueMapper: (ChartData data, _) => data.y3,
                            //   color: ColorPalette.potassiumBar,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
