import 'package:freezed_annotation/freezed_annotation.dart';

import 'soil.dart';

part 'soil_and_round.freezed.dart';
part 'soil_and_round.g.dart';

/// class that combines soil with a number of rounds
@freezed
class SoilAndRound with _$SoilAndRound {
  const factory SoilAndRound({
    required Soil soil,
    required int round,
  }) = _SoilAndRound;

  factory SoilAndRound.fromJson(Map<String, Object?> json) => _$SoilAndRoundFromJson(json);
}
