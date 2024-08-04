import 'dart:convert';

import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:agriworx/features/fertilizer/domain/weekly_fertilizer_selections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../local_storage/data/local_storage_repository.dart';
import '../../nutrient/domain/nutrient.dart';
import '../domain/fertilizer.dart';
import '../domain/fertilizer_data.dart';

part 'fertilizer_data_repository.g.dart';

List<WeeklyFertilizerSelections> listWithNoFertilizerSelections =
    List<WeeklyFertilizerSelections>.filled(
        numberOfWeeks, const WeeklyFertilizerSelections(selections: []));

@riverpod
class FertilizerDataRepository extends _$FertilizerDataRepository {
  late final LocalStorageRepository _localStorage;
  static const _currentFertilizerDataKey = 'currentFertilizerData'; // key for storing data

  @override
  FertilizerData build() {
    // reference to local storage repository
    _localStorage = ref.watch(localStorageRepositoryProvider);
    // start with loaded values from memory
    return loadFertilizerDataFromMemory();
  }

  /// save FertilizerData in local memory
  Future<void> _saveCurrentStateLocally() async {
    print('save to memory');
    await _localStorage.setString(
      key: _currentFertilizerDataKey,
      value: jsonEncode(state.toJson()),
    );
  }

  /// load FertilizerData from local memory
  FertilizerData loadFertilizerDataFromMemory() {
    // look for JSON data (map) in local memory
    final loadedFertilizerDataMap = _localStorage.getMap(key: _currentFertilizerDataKey);
    try {
      // create FertilizerData object
      final fertilizerData = FertilizerData.fromJson(loadedFertilizerDataMap!);
      return fertilizerData;
    } catch (error) {
      print('Could not load data from memory!');
      _localStorage.deleteValueFromMemory(key: _currentFertilizerDataKey);
      return FertilizerData(listOfWeeklyFertilizerSelections: listWithNoFertilizerSelections);
    }
  }

  Future<void> loadFertilizerDataFromSavedResult(FertilizerData fertilizerData) async {
    state = fertilizerData;
    await _saveCurrentStateLocally();
  }

  // /// for testing only
  // Future<void> deleteMemory() async {
  //   print('DELETE');
  //   await _localStorage.deleteValueFromMemory(key: _currentFertilizerDataKey);
  // }

  /// deleting all data
  Future<void> deleteAllData() async {
    state = state.copyWith(listOfWeeklyFertilizerSelections: listWithNoFertilizerSelections);
    await _saveCurrentStateLocally();
  }

  /// return all currently selected fertilizers of a specific week
  List<Fertilizer> getSelectedFertilizers(int weekNumber) {
    // get list of fertilizer selection of specific week
    final fertilizerSelections = state.listOfWeeklyFertilizerSelections[weekNumber];
    // get only list of fertilizers (no amount)
    final fertilizers = fertilizerSelections.selections.map((f) {
      return f.fertilizer;
    }).toList();
    return fertilizers;
  }

  /// change an existing fertilizer selection (specific week and index)
  void removeFertilizerSelection({
    required int weekNumber,
    required int index,
  }) {
    final copiedListOfWeeklyFertilizerSelections = [...state.listOfWeeklyFertilizerSelections];
    final weeklyFertilizerSelections = copiedListOfWeeklyFertilizerSelections[weekNumber];
    final weekList = [...weeklyFertilizerSelections.selections];

    if (index >= weekList.length) {
      print('Index outside of range!');
      return;
    }

    // remove entry at specified location
    weekList.removeAt(index);
    // create new object
    final newWeeklyFertilizerSelections = WeeklyFertilizerSelections(selections: weekList);
    // update copied list with modified week list
    copiedListOfWeeklyFertilizerSelections[weekNumber] = newWeeklyFertilizerSelections;
    // update state
    state =
        state.copyWith(listOfWeeklyFertilizerSelections: copiedListOfWeeklyFertilizerSelections);
    _saveCurrentStateLocally();
  }

  /// change an existing fertilizer selection (specific week and index)
  void changeOrAddFertilizerSelection({
    required int weekNumber,
    required int index,
    required FertilizerSelection fertilizerSelection,
  }) {
    final copiedListOfWeeklyFertilizerSelections = [...state.listOfWeeklyFertilizerSelections];
    final weeklyFertilizerSelections = copiedListOfWeeklyFertilizerSelections[weekNumber];
    final weekList = [...weeklyFertilizerSelections.selections];

    if (weekList.length >= index + 1) {
      // change existing entry
      weekList[index] = fertilizerSelection;
    } else {
      // add new entry if max number has not been reached
      if (weekList.length == maxNumberOfFertilizersPerWeek) {
        return;
      }
      weekList.add(fertilizerSelection);
    }
    // update state with modified week list
    final updatedWeeklyFertilizerSelections = WeeklyFertilizerSelections(selections: weekList);
    copiedListOfWeeklyFertilizerSelections[weekNumber] = updatedWeeklyFertilizerSelections;
    state =
        state.copyWith(listOfWeeklyFertilizerSelections: copiedListOfWeeklyFertilizerSelections);
    // save current state locally
    _saveCurrentStateLocally();
  }

  // returns a specific nutrient of a weekly selection in grams
  double getNutrientInGrams({required Nutrient nutrient, required int weekNumber}) {
    final weeklySelection = state.listOfWeeklyFertilizerSelections[weekNumber];

    double nutrientInGrams = 0;
    for (var selection in weeklySelection.selections) {
      nutrientInGrams += selection.getNutrientInGrams(nutrient);
    }
    return nutrientInGrams;
  }
}
