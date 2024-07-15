import 'package:agriworx/features/persons_involved/enumerator/data/enumerator_list_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../user/data/user_list_repository.dart';
import 'list_status.dart';

part 'loading_lists_provider.g.dart';

@riverpod
Future<({ListStatus e, ListStatus u})> loadingLists(LoadingListsRef ref) async {
  // needed to allow modifying other providers
  await Future.delayed(Duration.zero);

  // load enumerator list and get status
  final listStatusEnumerator = await ref
      .read(enumeratorListRepositoryProvider.notifier)
      .loadEnumeratorListFromMemoryAndCheckVersion();

  // load user list and get status
  final listStatusUser =
      await ref.read(userListRepositoryProvider.notifier).loadUserListFromMemoryAndCheckVersion();

  return (e: listStatusEnumerator, u: listStatusUser);
}
