import 'package:freezed_annotation/freezed_annotation.dart';

import 'fertilizer_selection.dart';

part 'weekly_fertilizer_selections.freezed.dart';
part 'weekly_fertilizer_selections.g.dart';

@freezed
class WeeklyFertilizerSelections with _$WeeklyFertilizerSelections {
  const factory WeeklyFertilizerSelections({
    required List<FertilizerSelection> selections,
  }) = _WeeklyFertilizerSelections;

  factory WeeklyFertilizerSelections.fromJson(Map<String, Object?> json) =>
      _$WeeklyFertilizerSelectionsFromJson(json);
}
