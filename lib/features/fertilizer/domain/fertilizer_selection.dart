import 'package:freezed_annotation/freezed_annotation.dart';

import 'amount.dart';
import 'fertilizer.dart';

part 'fertilizer_selection.freezed.dart';
part 'fertilizer_selection.g.dart';

@freezed
class FertilizerSelection with _$FertilizerSelection {
  const factory FertilizerSelection({
    required Fertilizer fertilizer,
    required Amount amount,
  }) = _FertilizerSelection;

  factory FertilizerSelection.fromJson(Map<String, Object?> json) =>
      _$FertilizerSelectionFromJson(json);
}
