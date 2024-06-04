import 'package:agriworx/features/fertilizer/domain/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'amount.dart';
import 'fertilizer.dart';
import 'nutrient.dart';

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

  double getNutrientInGrams(Nutrient nutrient) {
    final selectedUnit = amount.unit;

    final specificWeightInGrams = switch (selectedUnit) {
      Unit.tampeco => fertilizer.weightTampecoInGrams,
      Unit.blueBottlecap => fertilizer.weightBlueCapInGrams,
      Unit.glassBottlecap => fertilizer.weightGlassCapInGrams,
    };

    final nutrientPercentage = switch (nutrient) {
      Nutrient.nitrogen => fertilizer.nitrogenPercentage,
      Nutrient.phosphorus => fertilizer.phosphorusPercentage,
      Nutrient.potassium => fertilizer.potassiumPercentage,
    };

    final nutrientInGrams = amount.count * specificWeightInGrams * nutrientPercentage;
    // * nutrient.scalingFactor;

    return nutrientInGrams;
  }
}
