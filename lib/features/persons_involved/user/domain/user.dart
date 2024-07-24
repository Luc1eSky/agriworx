import 'package:freezed_annotation/freezed_annotation.dart';

import '../../group/domain/group.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();
  const factory User({
    required String uid,
    required String firstName,
    required String lastName,
    required Group group,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
