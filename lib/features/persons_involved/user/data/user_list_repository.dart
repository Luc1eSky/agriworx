import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../local_storage/data/local_storage_repository.dart';
import '../domain/user.dart';
import '../domain/user_list.dart';

part 'user_list_repository.g.dart';

@Riverpod(keepAlive: true)
class UserListRepository extends _$UserListRepository {
  late final LocalStorageRepository _localStorage;
  static const _userListKey = 'userList'; // key for storing data
  final _firestore = FirebaseFirestore.instance;

  @override
  UserList? build() {
    // reference to local storage repository
    _localStorage = ref.watch(localStorageRepositoryProvider);
    // load from memory by default
    return loadUserListFromMemory();
  }

  /// save UserList to local memory
  Future<void> _saveCurrentStateLocally() async {
    if (state != null) {
      print('save user list to memory');
      await _localStorage.setString(
        key: _userListKey,
        value: jsonEncode(state!.toJson()),
      );
    } else {
      print('Could not save user list to memory as value was "null".');
    }
  }

  Future<void> saveNewUserList(UserList newUserList) async {
    state = newUserList;
    await _saveCurrentStateLocally();
  }

  /// load User from local memory and check if there is a newer version
  /// available in firestore (returns true if newer version exists)
  UserList? loadUserListFromMemory() {
    // try to load user list from memory
    final userListMap = _localStorage.getMap(key: _userListKey);
    UserList? userListFromMemory;
    try {
      userListFromMemory = UserList.fromJson(userListMap!);
      return userListFromMemory;
    } catch (e) {
      print('ERROR: $e');
      return null;
    }

    //
    // // get updatedOn Datetime from list in memory (can be Datetime or null)
    // //final updatedOnMemory = userListFromMemory?.updatedOn;
    //
    // // try to get version document
    // final versionDocSnap = await _firestore.collection('users').doc('version').get();
    //
    // // check if version document is from firestore (not from cache!)
    // if (versionDocSnap.exists && !versionDocSnap.metadata.isFromCache) {
    //   final DateTime updatedOnFirestore = versionDocSnap.get('updatedOn').toDate();
    //   print('updatedOn: $updatedOnFirestore');
    //
    //   // if there is no version yet in memory, but one in firestore
    //   if (updatedOnMemory == null) {
    //     print('No user list in memory, but found one online.');
    //     return ListStatus.noListInMemoryButListInDatabase;
    //   }
    //
    //   // check if version in firestore is newer than version in memory
    //   if (updatedOnFirestore.isAfter(updatedOnMemory)) {
    //     print('User list found in memory, but found newer one online.');
    //     return ListStatus.listInMemoryButNewerListInDatabase;
    //   }
    //
    //   // no newer version found in firestore
    //   print('User list found in memory, but could not find newer one online.');
    //   return ListStatus.listInMemoryNoNewerListInDatabase;
    // }
    // // handle case if no internet connection is available
    // else {
    //   // no list in memory available
    //   if (userListFromMemory == null) {
    //     print('No user list found in memory and no online connection.');
    //     return ListStatus.noListInMemoryNoListInDatabase;
    //   }
    //
    //   // no newer version available (no internet connection)
    //   print('User list found in memory and no online connection.');
    //   return ListStatus.listInMemoryNoNewerListInDatabase;
    // }
  }

  /// download all user documents and save UserList entry in memory
  Future<void> downloadUserList() async {
    // get all document snapshots of user collection
    final collectionSnapshot = await _firestore.collection('users').get();
    final docSnapshots = collectionSnapshot.docs;

    // get version document and read "updatedOn" datetime
    final versionDocSnapshot = docSnapshots.firstWhere((docSnap) => docSnap.id == 'version');
    final updatedOn = versionDocSnapshot.get('updatedOn').toDate() as DateTime;

    // remove version document snapshot from list
    docSnapshots.remove(versionDocSnapshot);

    // convert all documents to users
    final users = docSnapshots.map((docSnap) => User.fromJson(docSnap.data())).toList();

    // create UserList with datetime from version doc and enumerators
    final downloadedUserList = UserList(users: users);

    print('downloadedUserList: $downloadedUserList');

    // update state and save EnumeratorList in local memory
    state = downloadedUserList;
    await _saveCurrentStateLocally();
  }
}
