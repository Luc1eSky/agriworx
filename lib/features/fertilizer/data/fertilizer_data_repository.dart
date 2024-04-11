import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constants.dart';
import '../domain/fertilizer_data.dart';

List<List<FertilizerSelection>> listOfEmptyLists = List<List<FertilizerSelection>>.filled(10, []);

class FertilizerDataRepository extends Notifier<FertilizerData> {
  //late final SharedPreferences _prefs;
  //static const _startingLevelDataString = 'startingLevelData'; // key for storing data

  @override
  FertilizerData build() {
    // Important: shared prefs need to be initialized
    // before any function is called (done in main before app starts)
    //_prefs = ref.watch(sharedPreferencesProvider);
    // this will be overridden once loadDataFromMemory() is called
    return FertilizerData(listOfSelectedFertilizers: listOfEmptyLists);
  }

  /// deleting all data
  void deleteAllData() {
    state = state.copyWith(listOfSelectedFertilizers: listOfEmptyLists);
  }

  /// add a new fertilizer selection to a specific week
  void addFertilizerSelection({
    required int weekNumber,
    required FertilizerSelection fertilizerSelection,
  }) {
    final copiedList = [...state.listOfSelectedFertilizers];
    final weekList = [...copiedList[weekNumber]];
    if (weekList.length < maxNumberOfFertilizersPerWeek) {
      weekList.add(fertilizerSelection);
      copiedList[weekNumber] = weekList;
      print(copiedList);
      state = state.copyWith(listOfSelectedFertilizers: copiedList);
    }
  }

  /// change an existing fertilizer selection (specific week and index)
  void changeFertilizerSelection(
      {required int weekNumber,
      required int index,
      required FertilizerSelection fertilizerSelection}) {
    print('change fertilizer in week $weekNumber with index $index');
    final copiedList = [...state.listOfSelectedFertilizers];
    final weekList = [...copiedList[weekNumber]];

    weekList[index] = fertilizerSelection;
    copiedList[weekNumber] = weekList;
    print(copiedList);
    state = state.copyWith(listOfSelectedFertilizers: copiedList);
  }
}

final fertilizerDataRepositoryProvider =
    NotifierProvider<FertilizerDataRepository, FertilizerData>(() {
  return FertilizerDataRepository();
});
