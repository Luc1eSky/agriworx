import 'package:freezed_annotation/freezed_annotation.dart';

import 'fertilizer_selection.dart';

part 'fertilizer_data.freezed.dart';
part 'fertilizer_data.g.dart';

@freezed
class FertilizerData with _$FertilizerData {
  const FertilizerData._();
  const factory FertilizerData({
    required List<List<FertilizerSelection>> listOfSelectedFertilizers,
  }) = _FertilizerData;

  bool get hasData => listOfSelectedFertilizers
      .any((listOfFertilizerSelection) => listOfFertilizerSelection.isNotEmpty);

  factory FertilizerData.fromJson(Map<String, Object?> json) => _$FertilizerDataFromJson(json);
}
