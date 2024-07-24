import 'package:agriworx/features/google_sheets/data/google_sheets_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'lists_updated_on_repository.dart';

part 'checking_versions_provider.g.dart';

@riverpod
Future<VersionState> checkingVersions(CheckingVersionsRef ref) async {
  // needed to allow modifying other providers
  await Future.delayed(Duration.zero);
  final updatedOnMemory = ref.read(listsUpdatedOnRepositoryProvider);

  final versionState =
      await ref.read(googleSheetsRepositoryProvider).compareVersions(updatedOnMemory);

  print('versionState: $versionState');
  return versionState;
}
