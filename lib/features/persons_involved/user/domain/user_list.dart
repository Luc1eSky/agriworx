import 'package:agriworx/features/persons_involved/user/domain/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_list.freezed.dart';
part 'user_list.g.dart';

@freezed
class UserList with _$UserList {
  const factory UserList({
    required DateTime updatedOn,
    required List<User> users,
  }) = _UserList;

  factory UserList.fromJson(Map<String, Object?> json) => _$UserListFromJson(json);
}
