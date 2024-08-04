import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'show_results_dialog.dart';

class ShowResultsButton extends ConsumerWidget {
  const ShowResultsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const ShowResultsDialog(),
        );
      },
      child: const Text('Show Results'),
    );
  }
}
