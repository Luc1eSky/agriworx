import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constants.dart';
import '../../nutrient/domain/nutrient.dart';
import '../domain/fertilizer.dart';
import '../domain/fertilizer_data.dart';

List<List<FertilizerSelection>> listOfEmptyLists =
    List<List<FertilizerSelection>>.filled(numberOfWeeks, []);

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

  /// return all currently selected fertilizers of a specific week
  List<Fertilizer> getSelectedFertilizers(int weekNumber) {
    // get list of fertilizer selection of specific week
    final fertilizerSelections = state.listOfSelectedFertilizers[weekNumber];
    // get only list of fertilizers (no amount)
    final fertilizers = fertilizerSelections.map((f) {
      return f.fertilizer;
    }).toList();
    return fertilizers;
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

  // /// change an existing fertilizer selection (specific week and index)
  // void changeFertilizerSelection(
  //     {required int weekNumber,
  //     required int index,
  //     required FertilizerSelection fertilizerSelection}) {
  //   print('change fertilizer in week $weekNumber with index $index');
  //   final copiedList = [...state.listOfSelectedFertilizers];
  //   final weekList = [...copiedList[weekNumber]];
  //
  //   weekList[index] = fertilizerSelection;
  //   copiedList[weekNumber] = weekList;
  //   print(copiedList);
  //   state = state.copyWith(listOfSelectedFertilizers: copiedList);
  // }

  /// change an existing fertilizer selection (specific week and index)
  void removeFertilizerSelection({
    required int weekNumber,
    required int index,
  }) {
    final copiedList = [...state.listOfSelectedFertilizers];
    final weekList = [...copiedList[weekNumber]];

    if (index >= weekList.length) {
      print('Index outside of range!');
      return;
    }

    // remove entry at specified location
    weekList.removeAt(index);
    // update copied list with modified week list
    copiedList[weekNumber] = weekList;
    // update state
    state = state.copyWith(listOfSelectedFertilizers: copiedList);
  }

  /// change an existing fertilizer selection (specific week and index)
  void changeOrAddFertilizerSelection({
    required int weekNumber,
    required int index,
    required FertilizerSelection fertilizerSelection,
  }) {
    final copiedList = [...state.listOfSelectedFertilizers];
    final weekList = [...copiedList[weekNumber]];

    if (weekList.length >= index + 1) {
      // change existing entry
      weekList[index] = fertilizerSelection;
      copiedList[weekNumber] = weekList;
      state = state.copyWith(listOfSelectedFertilizers: copiedList);
    } else {
      // add new entry
      if (weekList.length < maxNumberOfFertilizersPerWeek) {
        weekList.add(fertilizerSelection);
        copiedList[weekNumber] = weekList;
        state = state.copyWith(listOfSelectedFertilizers: copiedList);
      }
    }
  }

  // returns a specific nutrient of a weekly selection in grams
  double getNutrientInGrams({required Nutrient nutrient, required int weekNumber}) {
    final weeklySelection = state.listOfSelectedFertilizers[weekNumber];

    double nutrientInGrams = 0;
    for (var selection in weeklySelection) {
      nutrientInGrams += selection.getNutrientInGrams(nutrient);
    }
    return nutrientInGrams;
  }
}

final fertilizerDataRepositoryProvider =
    NotifierProvider<FertilizerDataRepository, FertilizerData>(() {
  return FertilizerDataRepository();
});
