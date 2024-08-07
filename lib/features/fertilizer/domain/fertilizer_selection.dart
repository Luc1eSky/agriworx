import 'package:agriworx/features/fertilizer/domain/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../nutrient/domain/nutrient.dart';
import 'amount.dart';
import 'fertilizer.dart';

part 'fertilizer_selection.freezed.dart';
part 'fertilizer_selection.g.dart';

@freezed
class FertilizerSelection with _$FertilizerSelection {
  // needed for methods and getters
  const FertilizerSelection._();
  const factory FertilizerSelection({
    required Fertilizer fertilizer,
    required Amount amount,
  }) = _FertilizerSelection;

  factory FertilizerSelection.fromJson(Map<String, Object?> json) =>
      _$FertilizerSelectionFromJson(json);

  double getFertilizerInGrams() {
    final specifWeightInGrams = switch (amount.unit) {
      Unit.tampeco => fertilizer.weightTampecoInGrams,
      Unit.blueBottlecap => fertilizer.weightBlueCapInGrams,
      Unit.glassBottlecap => fertilizer.weightGlassCapInGrams,
      Unit.grams => 1.0,
    };
    final fertilizerInGrams = amount.count * specifWeightInGrams;
    return fertilizerInGrams;
  }

  double getCostsInUgx() {
    final fertilizerInGrams = getFertilizerInGrams();
    return fertilizerInGrams * fertilizer.pricePerGramInUgx;
  }

  double getNutrientInGrams(Nutrient nutrient) {
    final nutrientPercentage = switch (nutrient) {
      Nutrient.nitrogen => fertilizer.nitrogenPercentage,
      Nutrient.phosphorus => fertilizer.phosphorusPercentage,
      Nutrient.potassium => fertilizer.potassiumPercentage,
    };

    final nutrientInGrams = getFertilizerInGrams() * nutrientPercentage;
    // * nutrient.scalingFactor;

    return nutrientInGrams;
  }
}
