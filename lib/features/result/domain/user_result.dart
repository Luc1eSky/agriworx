import 'package:agriworx/features/persons_involved/user/domain/user.dart';
import 'package:agriworx/features/result/domain/round_result.dart';
import 'package:agriworx/features/soil_and_round/domain/soil_and_round.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_result.freezed.dart';
part 'user_result.g.dart';

@freezed
class UserResult with _$UserResult {
  const UserResult._();
  const factory UserResult({
    required User user,
    required List<RoundResult> roundResults,
  }) = _UserResult;

  factory UserResult.fromJson(Map<String, Object?> json) => _$UserResultFromJson(json);

  // check if user has finished all assigned rounds
  bool get isFinished {
    // go through all soils from target info of group of user
    for (SoilAndRound roundAndSoil in user.group.targetRounds) {
      final soil = roundAndSoil.soil;
      final round = roundAndSoil.round;
      // only continue if at least one round has to be played for current soil
      if (round > 0) {
        // if target count was not reached for any soil return false
        final resultCountForSpecificSoil =
            roundResults.where((result) => result.soilAndRound.soil == soil).length;
        if (resultCountForSpecificSoil < round) {
          return false;
        }
      }
    }
    return true;
  }
}
