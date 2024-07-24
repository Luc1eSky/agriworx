import 'package:freezed_annotation/freezed_annotation.dart';

part 'enumerator.freezed.dart';
part 'enumerator.g.dart';

@freezed
class Enumerator with _$Enumerator {
  const Enumerator._();
  const factory Enumerator({
    required String uid,
    required String firstName,
    required String lastName,
  }) = _Enumerator;

  factory Enumerator.fromJson(Map<String, Object?> json) => _$EnumeratorFromJson(json);

  /// creates an enumerator object from a Google sheet row (json format from gsheets package)
  factory Enumerator.fromGSheets(Map<String, String> json) {
    // handle missing entries
    final uid = json['uid'];
    final firstName = json['firstName'];
    final lastName = json['lastName'];
    if (uid == null || uid == '') {
      throw Exception('Could not find "uid" for enumerator!');
    }
    if (firstName == null || firstName == '') {
      throw Exception('Could not find "firstName" for enumerator with uid $uid!');
    }
    if (lastName == null || lastName == '') {
      throw Exception('Could not find "lastName" for enumerator with uid $uid!');
    }

    // return enumerator if all entries are there
    return Enumerator(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
