import 'package:agriworx/local_storage/data/local_storage_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_code_repository.g.dart';

class DeviceCodeRepository {
  DeviceCodeRepository({
    required this.firestore,
    required this.localStorageRepository,
  });

  final FirebaseFirestore firestore;
  final LocalStorageRepository localStorageRepository;

  static const String _deviceCodeMemoryKey = 'deviceCode';

  // load code from memory
  String? loadCodeFromMemory() {
    return localStorageRepository.getString(key: _deviceCodeMemoryKey);
  }

  // save code to memory
  Future<bool> saveCodeToMemory(String code) async {
    return localStorageRepository.setString(key: _deviceCodeMemoryKey, value: code);
  }

  // get existing code of device from firestore
  Future<String?> getExistingCodeFromFirestore(String deviceUid) async {
    final deviceDoc = await firestore.collection('devices').doc(deviceUid).get();
    return deviceDoc.data()?['code'].toString();
  }

  // get new code from list in firestore
  Future<String?> getNewCodeFromFirestore() async {
    final deviceCodesDocRef = firestore.collection('deviceCodes').doc('deviceCodes');

    return firestore.runTransaction((transaction) {
      return transaction.get(deviceCodesDocRef).then((deviceCodesDoc) {
        final dynamicCodeList = deviceCodesDoc.data()?['codes'] as List<dynamic>;
        final codeList = dynamicCodeList.map((code) => code.toString()).toList();
        final lastElement = codeList.removeAt(codeList.length - 1);
        transaction.update(deviceCodesDocRef, {'codes': codeList});
        return lastElement;
      }).then(
        (lastElement) => lastElement,
        onError: (e) => null,
      );
    });
  }

  // save device uid and code in firestore
  Future<void> saveDeviceAndCodeInFirestore({
    required String deviceUid,
    required String code,
  }) async {
    await firestore.collection('devices').doc(deviceUid).set({'code': code});
  }
}

@riverpod
DeviceCodeRepository deviceCodeRepository(DeviceCodeRepositoryRef ref) {
  return DeviceCodeRepository(
    firestore: FirebaseFirestore.instance,
    localStorageRepository: ref.watch(localStorageRepositoryProvider),
  ); // TODO: MAKE FirebaseFirestore.instance PROVIDER
}
