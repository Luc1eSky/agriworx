import 'package:agriworx/features/result/domain/user_result.dart';
import 'package:agriworx/features/result/presentation/upload/upload_results_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadResultsButton extends ConsumerWidget {
  const UploadResultsButton({
    required this.userResult,
    super.key,
  });

  final UserResult userResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerState = ref.watch(uploadResultsButtonControllerProvider);
    return IconButton(
      icon: const Icon(Icons.upload_outlined),
      onPressed: controllerState.isLoading
          ? null
          : () async {
              ref
                  .read(uploadResultsButtonControllerProvider.notifier)
                  .uploadResultToFirestoreAndDeleteLocally(userResult: userResult);
            },
    );
  }
}
