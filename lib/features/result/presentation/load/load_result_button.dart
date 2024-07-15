import 'package:agriworx/features/persons_involved/user/data/user_repository.dart';
import 'package:agriworx/features/result/presentation/load/loaded_results_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/result_repository.dart';

class LoadResultButton extends ConsumerWidget {
  const LoadResultButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        final currentUser = ref.read(userRepositoryProvider);
        final loadedResults =
            ref.read(resultRepositoryProvider).loadResultsFromMemory(currentUser!);

        showDialog(
          context: context,
          builder: (context) => LoadedResultsDialog(loadedResults: loadedResults),
        );
      },
      child: const Text('LOAD'),
    );
  }
}
