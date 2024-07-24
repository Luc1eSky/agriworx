import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../local_storage/data/local_storage_repository.dart';

part 'lists_updated_on_repository.g.dart';

@Riverpod(keepAlive: true)
class ListsUpdatedOnRepository extends _$ListsUpdatedOnRepository {
  late final LocalStorageRepository _localStorage;
  static const _dateTimeKey = 'dateTime'; // key for storing data

  @override
  DateTime? build() {
    // reference to local storage repository
    _localStorage = ref.watch(localStorageRepositoryProvider);
    // start with loaded values from memory
    return loadDateTimeFromMemory();
  }

  /// save User to local memory
  Future<void> _saveCurrentStateLocally() async {
    if (state != null) {
      print('save datetime $state to memory');
      await _localStorage.setString(
        key: _dateTimeKey,
        value: state!.toIso8601String(),
      );
    } else {
      print('Could not save datetime to memory as datetime was "null".');
    }
  }

  /// change user and save to local memory
  Future<void> changeDateTime(DateTime newDateTime) async {
    state = newDateTime;
    await _saveCurrentStateLocally();
  }

  /// load User from local memory
  DateTime? loadDateTimeFromMemory() {
    // look for String in local memory
    final loadedDateString = _localStorage.getString(key: _dateTimeKey);
    try {
      final loadedDateTime = DateTime.parse(loadedDateString!);
      return loadedDateTime;
    } catch (error) {
      print('Could not load datetime from memory!');
      _localStorage.deleteValueFromMemory(key: _dateTimeKey);
      return null;
    }
  }
}
