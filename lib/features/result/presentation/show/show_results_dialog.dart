import 'dart:math';

import 'package:agriworx/common_widgets/default_dialog.dart';
import 'package:agriworx/features/result/data/result_repository.dart';
import 'package:agriworx/features/result/presentation/upload/upload_results_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../upload/upload_results_button_controller.dart';

class ShowResultsDialog extends ConsumerWidget {
  const ShowResultsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storedResults = ref.read(resultRepositoryProvider).loadAllUserResultsFromMemory();
    storedResults.sort((a, b) => (a.isFinished == b.isFinished ? 0 : (a.isFinished ? -1 : 1)));
    final controllerState = ref.watch(uploadResultsButtonControllerProvider);
    return DefaultDialog(
      hasCloseButton: !controllerState.isLoading,
      title: 'Stored Results',
      child: SizedBox(
        height: min(MediaQuery.of(context).size.height * 0.4, storedResults.length * 64),
        child: ListView.builder(
            itemCount: storedResults.length,
            itemBuilder: (context, index) {
              return Card(
                color: storedResults[index].isFinished ? Colors.green : Colors.transparent,
                child: ListTile(
                  title: Row(
                    children: [
                      Text(storedResults[index].user.fullName),
                      const Spacer(),
                      Text('rounds played: ${storedResults[index].roundResults.length.toString()}'),
                      const Spacer(),
                    ],
                  ),
                  trailing: UploadResultsButton(userResult: storedResults[index]),
                ),
              );
            }),
      ),
    );
  }
}
