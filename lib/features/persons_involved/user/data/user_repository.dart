import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../local_storage/data/local_storage_repository.dart';
import '../domain/user.dart';

part 'user_repository.g.dart';

@Riverpod(keepAlive: true)
class UserRepository extends _$UserRepository {
  late final LocalStorageRepository _localStorage;
  static const _userKey = 'user'; // key for storing data

  @override
  User? build() {
    // reference to local storage repository
    _localStorage = ref.watch(localStorageRepositoryProvider);
    // start with loaded values from memory
    return loadUserFromMemory();
  }

  /// save User to local memory
  Future<void> _saveCurrentStateLocally() async {
    if (state != null) {
      print('save user $state to memory');
      await _localStorage.setString(
        key: _userKey,
        value: jsonEncode(state!.toJson()),
      );
    } else {
      print('Could not save user to memory as user was "null".');
    }
  }

  /// change user and save to local memory
  Future<void> changeUser(User newUser) async {
    state = newUser;
    await _saveCurrentStateLocally();
  }

  /// load User from local memory
  User? loadUserFromMemory() {
    // look for String in local memory
    final loadedUserMap = _localStorage.getMap(key: _userKey);
    try {
      // create FertilizerData object
      final loadedUser = User.fromJson(loadedUserMap!);
      return loadedUser;
    } catch (error) {
      print('Could not load user from memory!');
      _localStorage.deleteValueFromMemory(key: _userKey);
      return null;
    }
  }
}
