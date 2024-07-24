import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../local_storage/data/local_storage_repository.dart';
import '../domain/enumerator.dart';
import '../domain/enumerator_list.dart';

part 'enumerator_list_repository.g.dart';

@Riverpod(keepAlive: true)
class EnumeratorListRepository extends _$EnumeratorListRepository {
  late final LocalStorageRepository _localStorage;
  static const _enumeratorListKey = 'enumeratorList'; // key for storing data
  final _firestore = FirebaseFirestore.instance;

  @override
  EnumeratorList? build() {
    // reference to local storage repository
    _localStorage = ref.watch(localStorageRepositoryProvider);
    // load from memory by default
    return loadEnumeratorListFromMemory();
  }

  /// save EnumeratorList to local memory
  Future<void> _saveCurrentStateLocally() async {
    if (state != null) {
      print('save enumerator list to memory');
      await _localStorage.setString(
        key: _enumeratorListKey,
        value: jsonEncode(state!.toJson()),
      );
    } else {
      print('Could not save user list to memory as value was "null".');
    }
  }

  Future<void> saveNewEnumeratorList(EnumeratorList newEnumeratorList) async {
    state = newEnumeratorList;
    await _saveCurrentStateLocally();
  }

  /// load Enumerator from local memory and check if there is a newer version
  /// available in firestore (returns true if newer version exists)
  EnumeratorList? loadEnumeratorListFromMemory() {
    // try to load enumerator list from memory
    final enumeratorListMap = _localStorage.getMap(key: _enumeratorListKey);
    EnumeratorList? enumeratorListFromMemory;
    try {
      enumeratorListFromMemory = EnumeratorList.fromJson(enumeratorListMap!);
      print('enumeratorListFromMemory: $enumeratorListFromMemory');
      return enumeratorListFromMemory;
    } catch (e) {
      print('ERROR: $e');
      return null;
    }
    //
    // // get updatedOn Datetime from list in memory (can be Datetime or null)
    // final updatedOnMemory = enumeratorListFromMemory?.updatedOn;
    //
    // // try to get version document
    // final versionDocSnap = await _firestore.collection('enumerators').doc('version').get();
    //
    // // check if version document is from firestore (not from cache!)
    // if (versionDocSnap.exists && !versionDocSnap.metadata.isFromCache) {
    //   final DateTime updatedOnFirestore = versionDocSnap.get('updatedOn').toDate();
    //   print('updatedOn: $updatedOnFirestore');
    //
    //   // if there is no version yet in memory, but one in firestore
    //   if (updatedOnMemory == null) {
    //     print('No enumerator list in memory, but found one online.');
    //     return ListStatus.noListInMemoryButListInDatabase;
    //   }
    //
    //   // check if version in firestore is newer than version in memory
    //   if (updatedOnFirestore.isAfter(updatedOnMemory)) {
    //     print('Enumerator list found in memory, but found newer one online.');
    //     return ListStatus.listInMemoryButNewerListInDatabase;
    //   }
    //
    //   // no newer version found in firestore
    //   print('Enumerator list found in memory, but could not find newer one online.');
    //   return ListStatus.listInMemoryNoNewerListInDatabase;
    // }
    // // handle case if no internet connection is available
    // else {
    //   // no list in memory available
    //   if (enumeratorListFromMemory == null) {
    //     print('No enumerator list found in memory and no online connection.');
    //     return ListStatus.noListInMemoryNoListInDatabase;
    //   }
    //
    //   // no newer version available (no internet connection)
    //   print('Enumerator list found in memory and no online connection.');
    //   return ListStatus.listInMemoryNoNewerListInDatabase;
    // }
  }

  /// download all enumerator documents and save EnumeratorList entry in memory
  Future<void> downloadEnumeratorList() async {
    // get all document snapshots of enumerator collection
    final collectionSnapshot = await _firestore.collection('enumerators').get();
    final docSnapshots = collectionSnapshot.docs;

    // get version document and read "updatedOn" datetime
    final versionDocSnapshot = docSnapshots.firstWhere((docSnap) => docSnap.id == 'version');
    final updatedOn = versionDocSnapshot.get('updatedOn').toDate() as DateTime;

    // remove version document snapshot from list
    docSnapshots.remove(versionDocSnapshot);

    // convert all documents to enumerators
    final enumerators = docSnapshots.map((docSnap) => Enumerator.fromJson(docSnap.data())).toList();

    // create EnumeratorList with datetime from version doc and enumerators
    final downloadedEnumeratorList = EnumeratorList(enumerators: enumerators);

    print('downloadedEnumeratorList: $downloadedEnumeratorList');

    // update state and save EnumeratorList in local memory
    state = downloadedEnumeratorList;
    await _saveCurrentStateLocally();
  }
}
