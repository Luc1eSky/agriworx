import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_repository.g.dart';

/// repository that holds everything that has to do
/// with storing and accessing data locally
class LocalStorageRepository {
  LocalStorageRepository(this._prefs);
  final SharedPreferences _prefs;

  // get a boolean from local memory
  bool? getBool({required String key}) {
    return _prefs.getBool(key);
  }

  // get a String from local memory
  String? getString({required String key}) {
    return _prefs.getString(key);
  }

  // get a double from local memory
  double? getDouble({required String key}) {
    return _prefs.getDouble(key);
  }

  // get an int from local memory
  int? getInt({required String key}) {
    return _prefs.getInt(key);
  }

  // get a map from local memory
  Map<String, dynamic>? getMap({required String key}) {
    String? loadedString = _prefs.getString(key);
    try {
      return jsonDecode(loadedString!);
    } catch (error, stack) {
      return null;
    }
  }

  // store a boolean in local memory
  Future<bool> setBool({required String key, required bool value}) {
    return _prefs.setBool(key, value);
  }

  // store a String in local memory
  Future<bool> setString({required String key, required String value}) {
    return _prefs.setString(key, value);
  }

  // store a double in local memory
  Future<bool> setDouble({required String key, required double value}) {
    return _prefs.setDouble(key, value);
  }

  // store an int in local memory
  Future<bool> setInt({required String key, required int value}) {
    return _prefs.setInt(key, value);
  }

  // store a map in local memory
  Future<bool> setMap({required String key, required Map<String, dynamic> map}) {
    final mapAsJsonString = json.encode(map);
    return _prefs.setString(key, mapAsJsonString);
  }

  // remove data from memory
  Future<bool> deleteValueFromMemory({required String key}) async {
    return _prefs.remove(key);
  }
}

@riverpod
LocalStorageRepository localStorageRepository(LocalStorageRepositoryRef ref) {
  // will be overwritten with SharedPrefs instance
  throw UnimplementedError();
}
