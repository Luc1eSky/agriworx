import 'package:agriworx/features/persons_involved/enumerator/data/enumerator_list_repository.dart';
import 'package:agriworx/features/persons_involved/user/data/user_list_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../persons_involved/data/loading_lists_provider.dart';

part 'game_mode_selection_screen_controller.g.dart';

@riverpod
class GameModeSelectionScreenController extends _$GameModeSelectionScreenController {
  @override
  Future<void> build() async {
    // nothing to do
  }

  /// download enumerator or user list
  Future<void> downloadListAndRefresh({required bool isUser}) async {
    // set async state to loading
    state = const AsyncValue.loading();

    try {
      // get enumerator or user collection ref
      if (isUser) {
        //  download user list
        await ref.read(userListRepositoryProvider.notifier).downloadUserList();
      } else {
        //  download enumerator list
        await ref.read(enumeratorListRepositoryProvider.notifier).downloadEnumeratorList();
      }
    } catch (error, stack) {
      // set state to AsyncError
      state = AsyncError(error, stack);
    }
    // invalidate (aka. refresh) the current state of the loading provider.
    // this leads to an update on the list status for enumerator and user list
    // as they should now be downloaded and in memory. So the UI can update
    // accordingly (not showing the download buttons anymore, or allowing to start
    // an experiment)
    ref.invalidate(loadingListsProvider);
    state = const AsyncValue.data(null);
  }
}
