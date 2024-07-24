import 'package:agriworx/features/persons_involved/enumerator/domain/enumerator.dart';
import 'package:agriworx/features/persons_involved/user/domain/user.dart';
import 'package:agriworx/features/soil_and_round/domain/soil_and_round.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../fertilizer/domain/fertilizer_data.dart';

part 'result.freezed.dart';
part 'result.g.dart';

@freezed
class Result with _$Result {
  const factory Result({
    required User user,
    required Enumerator enumerator,
    required String comment,
    required FertilizerData fertilizerData,
    required SoilAndRound soilAndRound,
  }) = _Result;

  factory Result.fromJson(Map<String, Object?> json) => _$ResultFromJson(json);
}
