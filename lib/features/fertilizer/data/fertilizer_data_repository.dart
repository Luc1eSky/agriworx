import 'dart:convert';

import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../local_storage/data/local_storage_repository.dart';
import '../../nutrient/domain/nutrient.dart';
import '../domain/fertilizer.dart';
import '../domain/fertilizer_data.dart';

part 'fertilizer_data_repository.g.dart';

List<List<FertilizerSelection>> listOfEmptyLists =
    List<List<FertilizerSelection>>.filled(numberOfWeeks, []);

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
      return FertilizerData(listOfSelectedFertilizers: listOfEmptyLists);
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
    state = state.copyWith(listOfSelectedFertilizers: listOfEmptyLists);
    await _saveCurrentStateLocally();
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
    _saveCurrentStateLocally();
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
    _saveCurrentStateLocally();
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
