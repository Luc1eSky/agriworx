import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/game_mode/data/game_mode_repository.dart';
import 'package:agriworx/features/game_mode/presentation/pin_dialog.dart';
import 'package:agriworx/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/game_mode.dart';

class GameModeSelectionScreen extends ConsumerWidget {
  const GameModeSelectionScreen({super.key, required this.isClosable});

  final bool isClosable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameMode = ref.watch(gameModeRepositoryProvider);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please Select Mode:'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(gameModeRepositoryProvider.notifier)
                      .changeGameMode(GameMode.practice);
                  // delete fertilizer data from memory if game mode was switched
                  final gameModeHasSwitched = gameMode != GameMode.practice;
                  if (gameModeHasSwitched) {
                    await ref.read(fertilizerDataRepositoryProvider.notifier).deleteAllData();
                  }
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const GameScreen()));
                  }
                },
                child: const Text('Practice Mode'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  bool? pinWasCorrect =
                      await showDialog(context: context, builder: (context) => const PinDialog());
                  if (pinWasCorrect != null && pinWasCorrect) {
                    await ref
                        .read(gameModeRepositoryProvider.notifier)
                        .changeGameMode(GameMode.experiment);
                    // delete fertilizer data from memory if game mode was switched
                    final gameModeHasSwitched = gameMode != GameMode.experiment;
                    if (gameModeHasSwitched) {
                      await ref.read(fertilizerDataRepositoryProvider.notifier).deleteAllData();
                    }
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const GameScreen()));
                    }
                  }
                },
                child: const Text('Experiment Mode'),
              ),
              if (gameMode == GameMode.experiment) const SizedBox(height: 36),
              if (gameMode == GameMode.experiment)
                const Text('Currently in Experiment Mode. You '
                    'might have unsaved data that will '
                    'be lost if switching to Practice Mode.'),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: isClosable
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
