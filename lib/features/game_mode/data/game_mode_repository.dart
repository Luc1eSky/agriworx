import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../local_storage/data/local_storage_repository.dart';
import '../domain/game_mode.dart';

part 'game_mode_repository.g.dart';

@Riverpod(keepAlive: true)
class GameModeRepository extends _$GameModeRepository {
  late final LocalStorageRepository _localStorage;
  static const _gameModeKey = 'gameMode'; // key for storing data

  @override
  GameMode? build() {
    // reference to local storage repository
    _localStorage = ref.watch(localStorageRepositoryProvider);
    // start with loaded values from memory
    return loadGameModeFromMemory();
  }

  /// save GameMode from local memory
  Future<void> _saveCurrentStateLocally() async {
    print('save GameMode $state to memory');
    await _localStorage.setString(
      key: _gameModeKey,
      value: state!.name,
    );
  }

  /// change GameMode and save to local memory
  Future<void> changeGameMode(GameMode newGameMode) async {
    state = newGameMode;
    await _saveCurrentStateLocally();
  }

  /// load GameMode from local memory
  GameMode? loadGameModeFromMemory() {
    // look for String in local memory
    final loadedGameModeString = _localStorage.getString(key: _gameModeKey);
    try {
      // create FertilizerData object
      final loadedGameMode = GameMode.values.byName(loadedGameModeString!);
      return loadedGameMode;
    } catch (error, stack) {
      print('Could not load GameMode from memory!');
      _localStorage.deleteValueFromMemory(key: _gameModeKey);
      return null;
    }
  }
}
