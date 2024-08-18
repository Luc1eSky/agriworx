import 'package:agriworx/common_widgets/small_dialog.dart';
import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/fertilizer/presentation/calculation/fertilizer_calculation_dialog.dart';
import 'package:agriworx/features/fertilizer/presentation/fertilizer_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../style/color_palette.dart';
import '../../domain/fertilizer_selection.dart';

class ChartData {
  ChartData(this.x, this.y1, this.y2);
  final String x;
  final double y1;
  final double y2;
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
    final List<ChartData> chartData = [
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
          5.3,
        )
    ];
    return SmallDialog(
      title: 'Fertilizer Recommendation',
      child: Column(
        children: [
          SfCartesianChart(
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
            legend: Legend(
              isVisible: true,
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
                        child: Text(name),
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
            ],
          ),
          LayoutBuilder(builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(fertilizerRecommendation.length, (fertilizerIndex) {
                return FertilizerSelectionWidget(
                  maxWidth: constraints.maxWidth,
                  weekIndex: 0,
                  fertilizerIndex: fertilizerIndex,
                  fertilizerSelection: fertilizerRecommendation[fertilizerIndex],
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
