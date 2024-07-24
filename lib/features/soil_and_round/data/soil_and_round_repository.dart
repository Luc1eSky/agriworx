import 'dart:convert';

import 'package:agriworx/local_storage/data/local_storage_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/soil_and_round.dart';

part 'soil_and_round_repository.g.dart';

@riverpod
class SoilAndRoundRepository extends _$SoilAndRoundRepository {
  late final LocalStorageRepository _localStorage;
  static const _soilAndRoundKey = 'soil_and_round'; // key for storing data

  @override
  SoilAndRound? build() {
    // reference to local storage repository
    _localStorage = ref.watch(localStorageRepositoryProvider);
    // start with loaded values from memory
    return loadSoilAndRoundFromMemory();
  }

  /// save SoilAndRound to local memory
  Future<void> _saveCurrentStateLocally() async {
    if (state != null) {
      print('save SoilAndRound $state to memory');
      await _localStorage.setString(
        key: _soilAndRoundKey,
        value: jsonEncode(state!.toJson()),
      );
    } else {
      print('Could not save user to memory as user was "null".');
    }
  }

  /// change SoilAndRound and save to local memory
  Future<void> changeSoilAndRound(SoilAndRound soilAndRound) async {
    state = soilAndRound;
    await _saveCurrentStateLocally();
  }

  /// load SoilAndRound from local memory
  SoilAndRound? loadSoilAndRoundFromMemory() {
    // look for String in local memory
    final loadedSoilAndRoundMap = _localStorage.getMap(key: _soilAndRoundKey);
    try {
      // create FertilizerData object
      final loadedSoilAndRound = SoilAndRound.fromJson(loadedSoilAndRoundMap!);
      return loadedSoilAndRound;
    } catch (error) {
      print('Could not load SoilAndRound from memory!');
      _localStorage.deleteValueFromMemory(key: _soilAndRoundKey);
      return null;
    }
  }
}
