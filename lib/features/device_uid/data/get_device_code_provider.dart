import 'package:agriworx/features/device_uid/data/device_code_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_repository.dart';

part 'get_device_code_provider.g.dart';

@riverpod
Future<String> getDeviceCode(GetDeviceCodeRef ref) async {
  print('loading device UID');
  // 1. check memory for existing device short code
  final deviceCodeFromMemory = ref.read(deviceCodeRepositoryProvider).loadCodeFromMemory();
  // if there was a code, return it
  if (deviceCodeFromMemory != null) {
    print('return device code from memory');
    return deviceCodeFromMemory;
  }

  // 2. if there was no existing code: sign in anonymously
  final deviceUid = await ref.read(authRepositoryProvider).signInAnonymously();
  if (deviceUid == null) {
    throw Exception('Device was not identified. Please establish internet connection.');
  }

  // 3. check if a userUid doc exists, save code in memory, and return short code
  final deviceCodeFromFirestore =
      await ref.read(deviceCodeRepositoryProvider).getExistingCodeFromFirestore(deviceUid);

  if (deviceCodeFromFirestore != null) {
    final isStoredLocally =
        await ref.read(deviceCodeRepositoryProvider).saveCodeToMemory(deviceCodeFromFirestore);
    if (!isStoredLocally) {
      throw Exception('Could not store code in memory.');
    }
    print('return already saved device code from firestore');
    return deviceCodeFromFirestore;
  }

  // 4. if no code exists grab a new one, create device document,
  // and save short code in memory
  final newDeviceCode = await ref.read(deviceCodeRepositoryProvider).getNewCodeFromFirestore();
  if (newDeviceCode == null) {
    throw Exception('Could not assign code to device. No codes left in database.');
  }

  // save code under device uid in firestore
  await ref
      .read(deviceCodeRepositoryProvider)
      .saveDeviceAndCodeInFirestore(deviceUid: deviceUid, code: newDeviceCode);

  final isStoredLocally =
      await ref.read(deviceCodeRepositoryProvider).saveCodeToMemory(newDeviceCode);
  if (!isStoredLocally) {
    throw Exception('Could not store code in memory.');
  }

  print('return new device code from firestore');
  return newDeviceCode;
}
