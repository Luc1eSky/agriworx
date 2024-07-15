import 'package:freezed_annotation/freezed_annotation.dart';

part 'enumerator.freezed.dart';
part 'enumerator.g.dart';

@freezed
class Enumerator with _$Enumerator {
  const factory Enumerator({
    required String firstName,
    required String lastName,
    required String uid,
  }) = _Enumerator;

  factory Enumerator.fromJson(Map<String, Object?> json) => _$EnumeratorFromJson(json);
}
