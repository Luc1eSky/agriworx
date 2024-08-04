import 'dart:convert';

import 'package:agriworx/local_storage/data/local_storage_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../persons_involved/user/domain/user.dart';
import '../domain/round_result.dart';
import '../domain/user_result.dart';

part 'result_repository.g.dart';

class ResultRepository {
  ResultRepository({
    required this.firestore,
    required this.localStorageRepository,
  });

  final FirebaseFirestore firestore;
  final LocalStorageRepository localStorageRepository;

  static const String _resultsMemoryKey = 'userResults';

  /// save a round result of a specific user in memory
  Future<bool> saveRoundResultToMemory(RoundResult roundResult, User user) async {
    // 1. get strings list from memory
    final stringList = localStorageRepository.getStringList(key: _resultsMemoryKey);

    var userResultList = <UserResult>[];
    // 2. if no UserResult exists for any user, create a new list with one entry
    if (stringList == null) {
      final newUserResult = UserResult(user: user, roundResults: [roundResult]);
      userResultList = [newUserResult];
    }
    // 3. if some UserResult exists, check if if a UserResult exists for current user
    else {
      // 3.1 convert String list to list of user results
      final currentUserResultList =
          stringList.map((string) => UserResult.fromJson(jsonDecode(string))).toList();

      // 3.2 check if a UserResult exists for current user (returns null if not found)
      final currentUserResult =
          currentUserResultList.firstWhereOrNull((result) => result.user == user);
      // 3.2.1 handle case when no user result exists yet
      if (currentUserResult == null) {
        final newUserResult = UserResult(user: user, roundResults: [roundResult]);
        userResultList = [...currentUserResultList, newUserResult];
      }
      // 3.2.2 handle case when user result exists
      else {
        // get current round results
        final currentRoundResultsOfUser = currentUserResult.roundResults;
        // create new user result with updated round results
        final newUserResult =
            UserResult(user: user, roundResults: [...currentRoundResultsOfUser, roundResult]);
        // get index in list of user result
        final indexOfUserResult =
            currentUserResultList.indexWhere((result) => result == currentUserResult);
        // copy current list and overwrite old user result with updated one
        userResultList = [...currentUserResultList];
        userResultList[indexOfUserResult] = newUserResult;
      }
    }

    // 4. convert back to list of strings
    final newStringList = userResultList.map((result) => jsonEncode(result.toJson())).toList();
    return localStorageRepository.setStringList(key: _resultsMemoryKey, value: newStringList);
  }

  /// load user result from memory for a specific user
  UserResult? loadUserResultFromMemory(User currentUser) {
    // 1. get strings list from memory
    final stringList = localStorageRepository.getStringList(key: _resultsMemoryKey);
    if (stringList == null) {
      return null;
    }
    // 2. convert to list of results
    final userResultList =
        stringList.map((string) => UserResult.fromJson(jsonDecode(string))).toList();
    // 3. search for user result of current user (returns null if not found)
    final userResult = userResultList.firstWhereOrNull((result) => result.user == currentUser);

    return userResult;
  }

  /// load all user results from memory
  List<UserResult> loadAllUserResultsFromMemory() {
    // 1. get strings list from memory
    final stringList = localStorageRepository.getStringList(key: _resultsMemoryKey);
    if (stringList == null) {
      return [];
    }
    // 2. convert to list of results and return
    return stringList.map((string) => UserResult.fromJson(jsonDecode(string))).toList();
  }

  // // load results from memory
  // List<RoundResult> loadResultsFromMemory(User currentUser) {
  //   // 1. get strings list from memory
  //   final stringList = localStorageRepository.getStringList(key: _resultsMemoryKey);
  //   if (stringList == null) {
  //     return [];
  //   }
  //   // 2. convert to list of results
  //   final resultList =
  //       stringList.map((string) => RoundResult.fromJson(jsonDecode(string))).toList();
  //
  //   final filteredResultList = resultList.where((result) => result.user == currentUser).toList();
  //   return filteredResultList;
  // }

  // // save result to memory
  // Future<bool> saveResultToMemory(RoundResult result) async {
  //   // 1. get strings list from memory
  //   final stringList = localStorageRepository.getStringList(key: _resultsMemoryKey);
  //   var newResultList = <RoundResult>[];
  //   if (stringList != null) {
  //     // *2. convert to list of results
  //     final resultList =
  //         stringList.map((string) => RoundResult.fromJson(jsonDecode(string))).toList();
  //     // *3. add results to list
  //     newResultList = [...resultList, result];
  //   } else {
  //     newResultList = [result];
  //   }
  //   // 4. convert back to list of strings
  //   final newStringList = newResultList.map((result) => jsonEncode(result.toJson())).toList();
  //   // 5. save list of strings in memory
  //   return localStorageRepository.setStringList(key: _resultsMemoryKey, value: newStringList);
  // }

  // upload results to firestore
  Future<void> uploadUserResultToFirestore(UserResult userResult) async {
    // get a new document
    final newDocRef = firestore.collection("results").doc();
    await firestore.runTransaction((transaction) async {
      transaction.set(newDocRef, userResult.toJson());
    });
  }

  /// load user result from memory for a specific user
  Future<void> deleteUserResultFromMemory(UserResult userResultToDelete) async {
    // 1. get strings list from memory
    final stringList = localStorageRepository.getStringList(key: _resultsMemoryKey);
    if (stringList == null) {
      return;
    }

    // 2. convert to list of results
    final userResultList =
        stringList.map((string) => UserResult.fromJson(jsonDecode(string))).toList();

    // 3. remove specific user result
    userResultList.remove(userResultToDelete);

    // 4. convert list back to Json, then String
    final newStringList = userResultList.map((result) => jsonEncode(result.toJson())).toList();

    // 5. save updated string list in memory
    localStorageRepository.setStringList(key: _resultsMemoryKey, value: newStringList);
  }
}

@riverpod
ResultRepository resultRepository(ResultRepositoryRef ref) {
  return ResultRepository(
    firestore: FirebaseFirestore.instance,
    localStorageRepository: ref.watch(localStorageRepositoryProvider),
  );
}
