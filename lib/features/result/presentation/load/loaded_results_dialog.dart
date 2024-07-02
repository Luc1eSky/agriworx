import 'dart:math';

import 'package:agriworx/common_widgets/default_dialog.dart';
import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/result.dart';

class LoadedResultsDialog extends ConsumerWidget {
  const LoadedResultsDialog({super.key, required this.loadedResults});

  final List<Result> loadedResults;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultDialog(
      title: 'Stored Results',
      child: SizedBox(
        height: min(MediaQuery.of(context).size.height * 0.4, loadedResults.length * 60),
        child: ListView.builder(
            itemCount: loadedResults.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(loadedResults[index].comment),
                  trailing: IconButton(
                    icon: const Icon(Icons.upload_outlined),
                    onPressed: () {
                      ref
                          .read(fertilizerDataRepositoryProvider.notifier)
                          .loadFertilizerDataFromSavedResult(loadedResults[index].fertilizerData);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}
