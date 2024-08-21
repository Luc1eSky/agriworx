import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/default_dialog.dart';
import 'confirm_save_result_dialog_controller.dart';

final _formKey = GlobalKey<FormState>();

class ConfirmSaveResultDialog extends ConsumerStatefulWidget {
  const ConfirmSaveResultDialog({super.key});

  @override
  ConsumerState<ConfirmSaveResultDialog> createState() =>
      _ConfirmSaveResultDialogState();
}

class _ConfirmSaveResultDialogState
    extends ConsumerState<ConfirmSaveResultDialog> {
  final commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(confirmSaveResultDialogControllerProvider);

    return DefaultDialog(
      hasCloseButton: false,
      title: 'Save Round Result',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Please confirm that you want to save the current selection in memory and reset.'),
          const SizedBox(height: 20),
          Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: commentController,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Please enter comment',
                  labelText: 'Comment',
                  //icon: Icon(Icons.person),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: asyncState.isLoading
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: asyncState.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final comment = commentController.text;
                          ref
                              .read(confirmSaveResultDialogControllerProvider
                                  .notifier)
                              .saveResult(comment: comment);
                        }
                      },
                child: const Text('SAVE'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
