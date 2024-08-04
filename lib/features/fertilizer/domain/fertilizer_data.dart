import 'package:agriworx/features/fertilizer/domain/weekly_fertilizer_selections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fertilizer_data.freezed.dart';
part 'fertilizer_data.g.dart';

@freezed
class FertilizerData with _$FertilizerData {
  const FertilizerData._();
  const factory FertilizerData({
    required List<WeeklyFertilizerSelections> listOfWeeklyFertilizerSelections,
  }) = _FertilizerData;

  bool get hasData => listOfWeeklyFertilizerSelections
      .any((listOfFertilizerSelection) => listOfFertilizerSelection.selections.isNotEmpty);

  factory FertilizerData.fromJson(Map<String, Object?> json) => _$FertilizerDataFromJson(json);
}
