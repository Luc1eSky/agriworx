import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/soil.dart';

List<List<FertilizerSelection>> listOfEmptyLists = List<List<FertilizerSelection>>.filled(10, []);

class SoilRepository extends Notifier<Soil?> {
  //late final SharedPreferences _prefs;
  //static const _startingLevelDataString = 'startingLevelData'; // key for storing data

  @override
  Soil? build() {
    // Important: shared prefs need to be initialized
    // before any function is called (done in main before app starts)
    //_prefs = ref.watch(sharedPreferencesProvider);
    // this will be overridden once loadDataFromMemory() is called
    return null;
  }

  /// resets soil selection to null
  void resetSoil() {
    state = null;
  }

  /// select a specific soil
  void selectSoil(soil) {
    state = soil;
  }
}

final soilRepositoryProvider = NotifierProvider<SoilRepository, Soil?>(() {
  return SoilRepository();
});
