import 'package:agriworx/features/persons_involved/enumerator/domain/enumerator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'enumerator_list.freezed.dart';
part 'enumerator_list.g.dart';

@freezed
class EnumeratorList with _$EnumeratorList {
  const factory EnumeratorList({
    required List<Enumerator> enumerators,
  }) = _EnumeratorList;

  factory EnumeratorList.fromJson(Map<String, Object?> json) => _$EnumeratorListFromJson(json);
}
