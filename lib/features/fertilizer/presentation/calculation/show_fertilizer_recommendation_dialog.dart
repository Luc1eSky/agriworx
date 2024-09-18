import 'package:agriworx/common_widgets/small_dialog.dart';
import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/fertilizer/presentation/calculation/fertilizer_calculation_dialog.dart';
import 'package:agriworx/features/nutrient/domain/nutrient.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../domain/fertilizer_selection.dart';
import '../fertilizer_selection_widget.dart';

class ChartData {
  ChartData(this.x, this.y1, this.y2, this.color);
  final String x;
  final double y1;
  final double y2;
  final Color? color;
}

class ShowFertilizerRecommendationDialog extends StatelessWidget {
  const ShowFertilizerRecommendationDialog(
      {super.key,
      required this.fertilizerRecommendation,
      required this.nitrogenInGramsTarget,
      required this.phosphorusInGramsTarget,
      required this.potassiumInGramsTarget,
      required this.weekNumber});

  final int weekNumber;
  final List<FertilizerSelection> fertilizerRecommendation;
  final double nitrogenInGramsTarget;
  final double phosphorusInGramsTarget;
  final double potassiumInGramsTarget;

  @override
  Widget build(BuildContext context) {
    double getNutrientsFromFertilizers(Nutrient nutrient) {
      print('get nutrients from fertilizers $nutrient');
      double nutrientAmount = 0.0;
      for (int i = 0; i < fertilizerRecommendation.length; i++) {
        nutrientAmount +=
            fertilizerRecommendation[i].getNutrientInGrams(nutrient);
      }
      print('nutrientAmount: $nutrientAmount');
      nutrientAmount = double.parse(nutrientAmount.toStringAsFixed(2));
      return nutrientAmount;
    }

    final List<ChartData> chartData = <ChartData>[
      for (int i = 0; i < 3; i++)
        ChartData(
          i == 0
              ? 'N'
              : i == 1
                  ? 'P'
                  : 'K',
          i == 0
              ? nitrogenInGramsTarget
              : i == 1
                  ? phosphorusInGramsTarget
                  : potassiumInGramsTarget,
          i == 0
              ? getNutrientsFromFertilizers(Nutrient.nitrogen)
              : i == 1
                  ? getNutrientsFromFertilizers(Nutrient.phosphorus)
                  : getNutrientsFromFertilizers(Nutrient.potassium),
          i == 0
              ? ColorPalette.nitrogenBar
              : i == 1
                  ? ColorPalette.phosphorusBar
                  : ColorPalette.potassiumBar,
        ),
    ];
    return SmallDialog(
      title: 'Fertilizer Recommendation',
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: SfCartesianChart(
              // only show axis title when folded out
              primaryXAxis: false
                  ? const CategoryAxis(
                      title: AxisTitle(text: 'week'),
                    )
                  : const CategoryAxis(),
              primaryYAxis: true
                  ? const NumericAxis(
                      rangePadding: ChartRangePadding.auto,
                      title: AxisTitle(text: 'grams'),
                    )
                  : const NumericAxis(
                      rangePadding: ChartRangePadding.auto,
                    ),
              // legend: Legend(
              //   isVisible: true,
              //   position: LegendPosition.right,
              //   textStyle: const TextStyle(
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   legendItemBuilder: (name, chartSeries, __, ___) => SizedBox(
              //     width: 60,
              //     height: 30,
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Container(
              //             color: chartSeries?.color ?? Colors.transparent,
              //           ),
              //         ),
              //         const SizedBox(
              //           width: 8,
              //         ),
              //         Expanded(
              //           flex: 2,
              //           child: FittedBox(
              //             child: Text(name),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              series: [
                ColumnSeries<ChartData, String>(
                  name: 'Selected',
                  animationDuration: 100,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                  pointColorMapper: (ChartData data, _) {
                    if (data.x == 'N') {
                      return ColorPalette.nitrogenBar.withOpacity(0.5);
                    } else if (data.x == 'P') {
                      return ColorPalette.phosphorusBar.withOpacity(0.5);
                    } else {
                      return ColorPalette.potassiumBar.withOpacity(0.5);
                    }
                  },
                  // color: Colors.grey,
                  // borderColor: Colors.grey, // Sets the border color
                  // borderWidth: 2,
                  // Define the label text here
                  dataLabelMapper: (ChartData data, _) =>
                      'Target', // Display y1 value followed by "g"

                  // Enable and style the labels
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true, // Show labels
                    textStyle: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 12, // Text size
                      //fontWeight: FontWeight.bold, // Text weight
                    ),
                    labelAlignment: ChartDataLabelAlignment
                        .middle, // Align the label in the middle of the bar
                  ),
                ),
                ColumnSeries<ChartData, String>(
                  name: 'Solution',
                  animationDuration: 100,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  pointColorMapper: (ChartData data, _) {
                    if (data.x == 'N') {
                      return ColorPalette.nitrogenBar;
                    } else if (data.x == 'P') {
                      return ColorPalette.phosphorusBar;
                    } else {
                      return ColorPalette.potassiumBar;
                    }
                  },
                  // color: Colors.green,
                  // borderColor: Colors.green, // Sets the border color
                  // borderWidth: 2,
                  dataLabelMapper: (ChartData data, _) =>
                      'Solution', // Display y1 value followed by "g"

                  // Enable and style the labels
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true, // Show labels
                    textStyle: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 12, // Text size
                      //fontWeight: FontWeight.bold, // Text weight
                    ),
                    labelAlignment: ChartDataLabelAlignment
                        .middle, // Align the label in the middle of the bar
                  ),
                ),
              ],
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(fertilizerRecommendation.length,
                  (fertilizerIndex) {
                print(
                    'fertilizerRec: ${fertilizerRecommendation[fertilizerIndex]}');
                return FertilizerSelectionWidget(
                  maxWidth: constraints.maxWidth,
                  weekIndex: 0,
                  fertilizerIndex: fertilizerIndex,
                  fertilizerSelection:
                      fertilizerRecommendation[fertilizerIndex],
                );
              }),
            );
          }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    // otherwise move to next dialog
                    Navigator.of(context).pop();

                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => FertilizerCalculationDialog(
                        weekNumber: weekNumber,
                        nitrogenInGrams: nitrogenInGramsTarget,
                        phosphorusInGrams: phosphorusInGramsTarget,
                        potassiumInGrams: potassiumInGramsTarget,
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Back'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      onPressed: () {
                        ref
                            .read(fertilizerDataRepositoryProvider.notifier)
                            .changeAllFertilizerSelectionOfWeek(
                              weekNumber: weekNumber,
                              fertilizerSelectionList: fertilizerRecommendation,
                            );
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text('Ok'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
