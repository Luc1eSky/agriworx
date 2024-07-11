import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/result/presentation/save/confirm_save_result_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../game_mode/data/game_mode_repository.dart';
import '../../../game_mode/domain/game_mode.dart';

class SaveResultButton extends ConsumerWidget {
  const SaveResultButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameMode = ref.watch(gameModeRepositoryProvider);
    final fertilizerData = ref.watch(fertilizerDataRepositoryProvider);
    print('gameMode: $gameMode');

    return Visibility(
      visible: fertilizerData.hasData && gameMode == GameMode.experiment,
      child: FloatingActionButton(
        onPressed: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const ConfirmSaveResultDialog();
              });
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
