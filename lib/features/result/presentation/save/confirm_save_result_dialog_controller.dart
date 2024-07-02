import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../navigation/navigation_service.dart';
import '../../../device_uid/data/device_code_repository.dart';
import '../../../fertilizer/data/fertilizer_data_repository.dart';
import '../../data/result_repository.dart';
import '../../domain/result.dart';

part 'confirm_save_result_dialog_controller.g.dart';

@riverpod
class ConfirmSaveResultDialogController extends _$ConfirmSaveResultDialogController {
  @override
  Future<void> build() async {
    // nothing to do
  }

  Future<void> saveResult({
    required String comment,
  }) async {
    // set state to loading
    state = const AsyncValue.loading();

    try {
      // get fertilizer data and device code
      final fertilizerData = ref.read(fertilizerDataRepositoryProvider);
      // TODO: WHAT TO DO WHEN DEVICE CODE FROM MEMORY IS NULL
      // TODO: WHAT IS THE UNIQUE ID DISPLAYED?
      final deviceCode = ref.read(deviceCodeRepositoryProvider).loadCodeFromMemory() ?? 'XXX';
      // create result
      final result = Result(uid: deviceCode, comment: comment, fertilizerData: fertilizerData);
      final success = await ref.read(resultRepositoryProvider).saveResultToMemory(result);
      if (!success) {
        throw Exception('Could not write result to memory!');
      }
      // delete current data if successful
      ref.read(fertilizerDataRepositoryProvider.notifier).deleteAllData();
      // pop dialog
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (error, stack) {
      //TODO: HANDLE ASYNC ERRORS IN CONTROLLERS VIA AN OBSERVER
      state = AsyncError(error, stack);
    }
  }
}
