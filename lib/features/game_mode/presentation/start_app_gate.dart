import 'package:agriworx/features/game_mode/data/game_mode_repository.dart';
import 'package:agriworx/features/game_mode/presentation/game_mode_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../game_screen.dart';
import '../domain/game_mode.dart';

class StartAppGate extends ConsumerWidget {
  const StartAppGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get current GameMode
    final gameMode = ref.watch(gameModeRepositoryProvider);
    return gameMode == null
        ? const GameModeSelectionScreen(isClosable: false)
        : gameMode == GameMode.practice
            ? const GameScreen()
            : const GameModeSelectionScreen(isClosable: false);
  }
}
