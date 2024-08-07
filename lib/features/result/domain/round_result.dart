import 'package:agriworx/features/persons_involved/enumerator/domain/enumerator.dart';
import 'package:agriworx/features/soil_and_round/domain/soil_and_round.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../fertilizer/domain/fertilizer_data.dart';

part 'round_result.freezed.dart';
part 'round_result.g.dart';

@freezed
class RoundResult with _$RoundResult {
  const factory RoundResult({
    required Enumerator enumerator,
    required String comment,
    required FertilizerData fertilizerData,
    required SoilAndRound soilAndRound,
    required DateTime startedOn,
    required DateTime finishedOn,
    required double yieldInKg,
    required double revenueInUgx,
    required double profitInUgx,
  }) = _RoundResult;

  factory RoundResult.fromJson(Map<String, Object?> json) => _$RoundResultFromJson(json);
}
