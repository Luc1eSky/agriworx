import 'package:freezed_annotation/freezed_annotation.dart';

import '../../nutrient/domain/nutrient.dart';
import 'fertilizer_selection.dart';

part 'weekly_fertilizer_selections.freezed.dart';
part 'weekly_fertilizer_selections.g.dart';

@freezed
class WeeklyFertilizerSelections with _$WeeklyFertilizerSelections {
  // needed for methods and getters
  const WeeklyFertilizerSelections._();
  const factory WeeklyFertilizerSelections({
    required List<FertilizerSelection> selections,
  }) = _WeeklyFertilizerSelections;

  factory WeeklyFertilizerSelections.fromJson(Map<String, Object?> json) =>
      _$WeeklyFertilizerSelectionsFromJson(json);

  double getWeeklyCosts() {
    double totalCosts = 0;
    for (FertilizerSelection selection in selections) {
      totalCosts += selection.getCostsInUgx();
    }
    return totalCosts;
  }

  double getNutrientInGrams(Nutrient nutrient) {
    double nutrientInGrams = 0;
    for (FertilizerSelection selection in selections) {
      nutrientInGrams += selection.getNutrientInGrams(nutrient);
    }
    return nutrientInGrams;
  }
}
