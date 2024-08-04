import 'package:agriworx/features/persons_involved/enumerator/data/enumerator_repository.dart';
import 'package:agriworx/features/persons_involved/presentation/select_user_and_enumerator_screen.dart';
import 'package:agriworx/features/persons_involved/user/data/user_repository.dart';
import 'package:agriworx/features/soil_and_round/data/soil_and_round_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../navigation/navigation_service.dart';
import '../../../fertilizer/data/fertilizer_data_repository.dart';
import '../../data/result_repository.dart';
import '../../domain/round_result.dart';

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

      // create round result
      final currentEnumerator = ref.read(enumeratorRepositoryProvider);
      final currentSoilAndRound = ref.read(soilAndRoundRepositoryProvider);

      final roundResult = RoundResult(
        comment: comment,
        fertilizerData: fertilizerData,
        enumerator: currentEnumerator!,
        soilAndRound: currentSoilAndRound!,
        startedOn: DateTime.now(), // TODO: UPDATE FROM MEMORY
        finishedOn: DateTime.now(),
      );

      // save round result to memory (add to user result)
      final currentUser = ref.read(userRepositoryProvider);
      final success = await ref
          .read(resultRepositoryProvider)
          .saveRoundResultToMemory(roundResult, currentUser!);

      if (!success) {
        throw Exception('Could not write result to memory!');
      }

      // delete current data if successful
      await ref.read(fertilizerDataRepositoryProvider.notifier).deleteAllData();

      // check updated user result from memory
      final userResult = ref.read(resultRepositoryProvider).loadUserResultFromMemory(currentUser);
      // delete current user if all targets were met
      if (userResult != null && userResult.isFinished) {
        await ref.read(userRepositoryProvider.notifier).deselectUser();
      }

      // pop dialog
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SelectUserAndEnumeratorScreen()));
      }
    } catch (error, stack) {
      //TODO: HANDLE ASYNC ERRORS IN CONTROLLERS VIA AN OBSERVER
      state = AsyncError(error, stack);
    }
  }
}
