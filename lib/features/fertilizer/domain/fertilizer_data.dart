import 'package:agriworx/features/fertilizer/domain/weekly_fertilizer_selections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../nutrient/domain/nutrient.dart';

part 'fertilizer_data.freezed.dart';
part 'fertilizer_data.g.dart';

@freezed
class FertilizerData with _$FertilizerData {
  const FertilizerData._();
  const factory FertilizerData({
    required List<WeeklyFertilizerSelections> listOfWeeklyFertilizerSelections,
  }) = _FertilizerData;

  factory FertilizerData.fromJson(Map<String, Object?> json) => _$FertilizerDataFromJson(json);

  bool get hasData => listOfWeeklyFertilizerSelections
      .any((listOfFertilizerSelection) => listOfFertilizerSelection.selections.isNotEmpty);

  double getTotalCosts() {
    double totalFertilizerCosts = 0;
    int totalWeeksWithFertilizer = 0;
    for (var weeklySelection in listOfWeeklyFertilizerSelections) {
      totalFertilizerCosts += weeklySelection.getWeeklyCosts();
      if (weeklySelection.selections.isNotEmpty) {
        totalWeeksWithFertilizer++;
      }
    }

    totalFertilizerCosts +=
        laborCostsPerSplitPerPlant * totalWeeksWithFertilizer * plantsPerHectare * numberOfHectares;

    const totalNonFertilizerCosts = nonFertilizerCostsPerHectare * numberOfHectares;
    final totalCosts = totalFertilizerCosts + totalNonFertilizerCosts;

    return totalCosts;
  }

  double getYield() {
    double totalNitrogenInGrams = 0;
    double totalPhosphorusInGrams = 0;
    double totalPotassiumInGrams = 0;
    int weeksWithNitrogenAndPhosphorus = 0;

    for (var weeklySelection in listOfWeeklyFertilizerSelections) {
      final weeklyNitrogenInGrams = weeklySelection.getNutrientInGrams(Nutrient.nitrogen);
      totalNitrogenInGrams += weeklyNitrogenInGrams;
      final weeklyPhosphorusInGrams = weeklySelection.getNutrientInGrams(Nutrient.phosphorus);
      totalPhosphorusInGrams += weeklyPhosphorusInGrams;
      if (weeklyNitrogenInGrams != 0 && weeklyPhosphorusInGrams != 0) {
        weeksWithNitrogenAndPhosphorus++;
      }
      totalPotassiumInGrams += weeklySelection.getNutrientInGrams(Nutrient.potassium);
    }

    final expectedYieldInKgPerHa = betaSumN * totalNitrogenInGrams +
        betaSumP * totalPhosphorusInGrams +
        betaSumK * totalPotassiumInGrams +
        betaSplitNP * weeksWithNitrogenAndPhosphorus;

    return expectedYieldInKgPerHa * numberOfHectares;
  }
}

const int plantsPerHectare = 3300;
const double marketPricePerKgInUgx = 1250;
const double numberOfHectares = 0.1012;
const int nonFertilizerCostsPerHectare = 9000000; // e.g. irrigation etc.
const int laborCostsPerSplitPerPlant = 25;

const betaSumN = 1250;
const betaSumP = 1200;
const betaSumK = 1300;
const betaSplitNP = 1200;
