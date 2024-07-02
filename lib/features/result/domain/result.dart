import 'package:freezed_annotation/freezed_annotation.dart';

import '../../fertilizer/domain/fertilizer_data.dart';

part 'result.freezed.dart';
part 'result.g.dart';

@freezed
class Result with _$Result {
  const factory Result({
    required String uid,
    required String comment,
    required FertilizerData fertilizerData,
  }) = _Result;

  factory Result.fromJson(Map<String, Object?> json) => _$ResultFromJson(json);
}
