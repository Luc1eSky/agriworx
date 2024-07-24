import 'dart:convert';

import 'package:agriworx/features/persons_involved/enumerator/domain/enumerator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../local_storage/data/local_storage_repository.dart';

part 'enumerator_repository.g.dart';

@Riverpod(keepAlive: true)
class EnumeratorRepository extends _$EnumeratorRepository {
  late final LocalStorageRepository _localStorage;
  static const _enumeratorKey = 'enumerator'; // key for storing data

  @override
  Enumerator? build() {
    // reference to local storage repository
    _localStorage = ref.watch(localStorageRepositoryProvider);
    // start with loaded values from memory
    return loadEnumeratorFromMemory();
  }

  /// save Enumerator to local memory
  Future<void> _saveCurrentStateLocally() async {
    if (state != null) {
      print('save enumerator $state to memory');
      await _localStorage.setString(
        key: _enumeratorKey,
        value: jsonEncode(state!.toJson()),
      );
    } else {
      print('Could not save enumerator to memory as enumerator was "null".');
    }
  }

  /// change enumerator and save to local memory
  Future<void> changeEnumerator(Enumerator newEnumerator) async {
    state = newEnumerator;
    await _saveCurrentStateLocally();
  }

  /// load User from local memory
  Enumerator? loadEnumeratorFromMemory() {
    // look for String in local memory
    final loadedEnumeratorMap = _localStorage.getMap(key: _enumeratorKey);
    try {
      // create FertilizerData object
      final loadedEnumerator = Enumerator.fromJson(loadedEnumeratorMap!);
      return loadedEnumerator;
    } catch (error) {
      print('Could not load enumerator from memory!');
      _localStorage.deleteValueFromMemory(key: _enumeratorKey);
      return null;
    }
  }
}
