import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/game_mode/data/game_mode_repository.dart';
import 'package:agriworx/features/game_mode/presentation/game_mode_selection_screen_controller.dart';
import 'package:agriworx/features/game_mode/presentation/pin_dialog.dart';
import 'package:agriworx/features/persons_involved/enumerator/data/enumerator_repository.dart';
import 'package:agriworx/features/persons_involved/presentation/select_user_and_enumerator_screen.dart';
import 'package:agriworx/features/persons_involved/user/data/user_repository.dart';
import 'package:agriworx/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../persons_involved/data/list_status.dart';
import '../../persons_involved/data/loading_lists_provider.dart';
import '../domain/game_mode.dart';

class GameModeSelectionScreen extends ConsumerWidget {
  const GameModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch future provider that loads the user list from memory and
    // checks if newer version is available
    final loadingUserList = ref.watch(loadingListsProvider);
    // check state of controller to deactivate buttons while loading
    final downloadingListState = ref.watch(gameModeSelectionScreenControllerProvider);

    final enumerator = ref.watch(enumeratorRepositoryProvider);
    final user = ref.watch(userRepositoryProvider);

    final enumeratorAndUserAvailable = enumerator != null && user != null;

    /// sets GameMode and deletes FertilizerData from memory if GameMode is switched
    /// opens game screen or pops screen (when opened as overlay via settings)
    Future<void> setGameModeAndDeleteDataIfSwitched(GameMode newGameMode) async {
      final gameModeHasSwitched = ref.read(gameModeRepositoryProvider) != newGameMode;
      if (gameModeHasSwitched) {
        await ref.read(fertilizerDataRepositoryProvider.notifier).deleteAllData();
      }
      await ref.read(gameModeRepositoryProvider.notifier).changeGameMode(newGameMode);
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => newGameMode == GameMode.experiment
                ? enumeratorAndUserAvailable
                    ? const GameScreen()
                    : const SelectUserAndEnumeratorScreen()
                : const GameScreen(),
          ),
          (Route<dynamic> route) => false, // This will remove all previous routes
        );
      }
    }

    final gameMode = ref.watch(gameModeRepositoryProvider);
    return Scaffold(
      body: Center(
        child: loadingUserList.when(
          error: (error, stack) => Container(
            color: Colors.red,
            child: Center(
              child: Text(
                error.toString(),
              ),
            ),
          ),
          loading: () => const CircularProgressIndicator(),
          data: (listStatus) => SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Text('Enumerator: ${listStatus.e.text}'),
                if (listStatus.e.hasNewerList)
                  ElevatedButton(
                    onPressed: downloadingListState.isLoading
                        ? null
                        : () async {
                            final pinIsCorrect = await showDialog(
                              context: context,
                              builder: (context) => const PinDialog(),
                            );
                            if (pinIsCorrect) {
                              await ref
                                  .read(gameModeSelectionScreenControllerProvider.notifier)
                                  .downloadListAndRefresh(isUser: false);
                            }
                          },
                    child: const Text('Download'),
                  ),
                const SizedBox(height: 16),
                Text('User: ${listStatus.u.text}'),
                if (listStatus.u.hasNewerList)
                  ElevatedButton(
                    onPressed: downloadingListState.isLoading
                        ? null
                        : () async {
                            final pinIsCorrect = await showDialog(
                              context: context,
                              builder: (context) => const PinDialog(),
                            );
                            if (pinIsCorrect) {
                              await ref
                                  .read(gameModeSelectionScreenControllerProvider.notifier)
                                  .downloadListAndRefresh(isUser: true);
                            }
                          },
                    child: const Text('Download'),
                  ),
                const Spacer(),
                const Text('Please Select Mode:'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: downloadingListState.isLoading
                      ? null
                      : () async {
                          await setGameModeAndDeleteDataIfSwitched(GameMode.practice);
                        },
                  child: const Text('Practice Mode'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: listStatus.e.isInMemory &&
                          listStatus.u.isInMemory &&
                          !downloadingListState.isLoading
                      ? () async {
                          bool? pinWasCorrect = await showDialog(
                              context: context, builder: (context) => const PinDialog());
                          if (pinWasCorrect != null && pinWasCorrect) {
                            await setGameModeAndDeleteDataIfSwitched(GameMode.experiment);
                          }
                        }
                      : null,
                  child: const Text('Experiment Mode'),
                ),
                if (gameMode != null) const SizedBox(height: 36),
                if (gameMode == GameMode.practice) const Text('Currently in Practice Mode.'),
                if (gameMode == GameMode.experiment)
                  const Text('Currently in Experiment Mode. You '
                      'might have unsaved data that will '
                      'be lost if switching to Practice Mode.'),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Navigator.canPop(context)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.close),
            )
          : null,
    );
  }
}
