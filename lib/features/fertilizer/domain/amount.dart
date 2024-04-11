import 'package:agriworx/features/fertilizer/domain/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'amount.freezed.dart';
part 'amount.g.dart';

@freezed
class Amount with _$Amount {
  const factory Amount({
    required int count,
    required Unit unit,
  }) = _Amount;

  factory Amount.fromJson(Map<String, Object?> json) => _$AmountFromJson(json);
}
