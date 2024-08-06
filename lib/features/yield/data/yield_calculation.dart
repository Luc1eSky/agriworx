import 'package:agriworx/features/fertilizer/domain/fertilizer_data.dart';

// Inputs
const int plantsPerHectare = 3300;
const int marketPricePerKg = 1250;
const double numHectares = 0.1012;
const int nonfertCostPerHectare = 9000000;
const int laborCostPerSplitPerPlant = 25;

Map<String, int> fertPricesPerKg = {
  "Urea": 3800,
  "DAP": 4200,
  "MOP": 4500,
  "CAN": 4000,
  "TSP": 4000,
  "NPK-25-5-5": 3600,
  "NPK-17-17-17": 4000,
};

class YieldCalculation {
  void calculateYield(FertilizerData fertilizerData) {
    // calculate total fertilizer cost

    // sum up fertilizer weight over total period (each fertilizer in grams)

    // double totalFertCost = 0;
    // for (var config in fertilizerConfig) {
    //   totalFertCost += config.grams *
    //       plantsPerHectare *
    //       numHectares /
    //       1000 *
    //       fertPricesPerKg[config.fertilizer]!;
    // }
  }
}
