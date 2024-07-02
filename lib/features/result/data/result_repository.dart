import 'dart:convert';

import 'package:agriworx/local_storage/data/local_storage_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/result.dart';

part 'result_repository.g.dart';

class ResultRepository {
  ResultRepository({
    required this.firestore,
    required this.localStorageRepository,
  });

  final FirebaseFirestore firestore;
  final LocalStorageRepository localStorageRepository;

  static const String _resultsMemoryKey = 'results';

  // load results from memory
  List<Result> loadResultsFromMemory() {
    // 1. get strings list from memory
    final stringList = localStorageRepository.getStringList(key: _resultsMemoryKey);
    if (stringList == null) {
      return [];
    }
    // 2. convert to list of results
    final resultList = stringList.map((string) => Result.fromJson(jsonDecode(string))).toList();
    return resultList;
  }

  // save result to memory
  Future<bool> saveResultToMemory(Result result) async {
    // 1. get strings list from memory
    final stringList = localStorageRepository.getStringList(key: _resultsMemoryKey);
    var newResultList = <Result>[];
    if (stringList != null) {
      // *2. convert to list of results
      final resultList = stringList.map((string) => Result.fromJson(jsonDecode(string))).toList();
      // *3. add results to list
      newResultList = [...resultList, result];
    } else {
      newResultList = [result];
    }
    // 4. convert back to list of strings
    final newStringList = newResultList.map((result) => jsonEncode(result.toJson())).toList();
    // 5. save list of strings in memory
    return localStorageRepository.setStringList(key: _resultsMemoryKey, value: newStringList);
  }

  // upload results to firestore
  Future<void> uploadResultsToFirestore() async {
    //await firestore.collection('devices').doc(deviceUid).set({'code': code});
  }
}

@riverpod
ResultRepository resultRepository(ResultRepositoryRef ref) {
  return ResultRepository(
    firestore: FirebaseFirestore.instance,
    localStorageRepository: ref.watch(localStorageRepositoryProvider),
  );
}
