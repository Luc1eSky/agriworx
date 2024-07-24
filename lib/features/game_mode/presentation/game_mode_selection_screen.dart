import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/game_mode/data/game_mode_repository.dart';
import 'package:agriworx/features/game_mode/presentation/game_mode_selection_screen_controller.dart';
import 'package:agriworx/features/game_mode/presentation/pin_dialog.dart';
import 'package:agriworx/features/google_sheets/data/google_sheets_repository.dart';
import 'package:agriworx/features/persons_involved/data/checking_versions_provider.dart';
import 'package:agriworx/features/persons_involved/data/lists_updated_on_repository.dart';
import 'package:agriworx/features/persons_involved/presentation/select_user_and_enumerator_screen.dart';
import 'package:agriworx/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/game_mode.dart';

class GameModeSelectionScreen extends ConsumerWidget {
  const GameModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch future provider that loads the user list from memory and
    // checks if newer version is available
    final checkingVersionsState = ref.watch(checkingVersionsProvider);

    // watch current version in memory
    final updatedOnMemory = ref.watch(listsUpdatedOnRepositoryProvider);

    // check state of controller to deactivate buttons while loading
    final controllerState = ref.watch(gameModeSelectionScreenControllerProvider);

    final currentGameMode = ref.watch(gameModeRepositoryProvider);

    /// sets GameMode and deletes FertilizerData from memory if GameMode is switched
    /// opens game screen or pops screen (when opened as overlay via settings)
    Future<void> setGameModeAndDeleteDataIfSwitched(GameMode newGameMode) async {
      final gameModeHasSwitched = ref.read(gameModeRepositoryProvider) != newGameMode;
      if (gameModeHasSwitched) {
        await ref.read(fertilizerDataRepositoryProvider.notifier).deleteAllData();
        // TODO: DELETE ENUMERATOR AND USER DATA
      }
      await ref.read(gameModeRepositoryProvider.notifier).changeGameMode(newGameMode);
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => newGameMode == GameMode.experiment
                ? const SelectUserAndEnumeratorScreen()
                : const GameScreen(),
          ),
          (Route<dynamic> route) => false, // This will remove all previous routes
        );
      }
    }

    final gameMode = ref.watch(gameModeRepositoryProvider);
    return Scaffold(
      body: Center(
        child: checkingVersionsState.when(
          error: (error, stack) => Container(color: Colors.red),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (versionState) => Column(
            children: [
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: controllerState.isLoading || versionState == VersionState.noConnection
                    ? null
                    : () async {
                        // final pinIsCorrect = await showDialog(
                        //   context: context,
                        //   builder: (context) => const PinDialog(),
                        // );
                        // if (pinIsCorrect) {
                        await ref
                            .read(gameModeSelectionScreenControllerProvider.notifier)
                            .checkAndDownloadListsFromSheets();
                        //}
                      },
                child: const Text('CHECK FOR UPDATE'),
              ),
              const SizedBox(height: 24),
              // TODO: FORMAT DATE
              updatedOnMemory == null
                  ? const Text('No data in memory')
                  : Text('Data in memory: ${updatedOnMemory.toString()}'),
              const SizedBox(height: 12),
              Text('Database State: ${versionState.name}'),
              //versionState
              const Spacer(),
              const Text('Please Select Mode:'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: controllerState.isLoading || currentGameMode == GameMode.practice
                    ? null
                    : () async {
                        await setGameModeAndDeleteDataIfSwitched(GameMode.practice);
                      },
                child: const Text('Practice Mode'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controllerState.isLoading ||
                        updatedOnMemory == null ||
                        Navigator.canPop(context) && currentGameMode == GameMode.experiment
                    ? null
                    : () async {
                        bool? pinWasCorrect = await showDialog(
                            context: context, builder: (context) => const PinDialog());
                        if (pinWasCorrect != null && pinWasCorrect) {
                          await setGameModeAndDeleteDataIfSwitched(GameMode.experiment);
                        }
                      },
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Navigator.canPop(context)
          ? FloatingActionButton(
              onPressed: controllerState.isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              child: const Icon(Icons.close),
            )
          : null,
    );
  }
}
