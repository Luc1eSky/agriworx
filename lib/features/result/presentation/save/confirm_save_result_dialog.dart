import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../common_widgets/default_dialog.dart';
import 'confirm_save_result_dialog_controller.dart';

final _formKey = GlobalKey<FormState>();

String getFormattedNumber(double number) {
  return NumberFormat('#,###').format(number);
}

class ConfirmSaveResultDialog extends ConsumerStatefulWidget {
  const ConfirmSaveResultDialog({super.key});

  @override
  ConsumerState<ConfirmSaveResultDialog> createState() => _ConfirmSaveResultDialogState();
}

class _ConfirmSaveResultDialogState extends ConsumerState<ConfirmSaveResultDialog> {
  final commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(confirmSaveResultDialogControllerProvider);

    final yieldData = ref.watch(fertilizerDataRepositoryProvider).getYieldRevenueAndProfit();
    return DefaultDialog(
      hasCloseButton: false,
      title: 'Results',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expected Yield: ${getFormattedNumber(yieldData.yieldInKg)} kg',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Expected Return: ${getFormattedNumber(yieldData.revenueInUgx)} UGX',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Expected Profit: ${getFormattedNumber(yieldData.profitInUgx)} UGX',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 12),
          const Text('includes random shock'),
          const SizedBox(height: 40),
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
                              .read(confirmSaveResultDialogControllerProvider.notifier)
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
