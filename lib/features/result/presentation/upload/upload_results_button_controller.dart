import 'package:agriworx/features/result/data/result_repository.dart';
import 'package:agriworx/features/result/domain/user_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_results_button_controller.g.dart';

@riverpod
class UploadResultsButtonController extends _$UploadResultsButtonController {
  @override
  Future<void> build() async {
    // nothing to do
  }

  Future<void> uploadResultToFirestoreAndDeleteLocally({
    required UserResult userResult,
  }) async {
    // set state to loading
    state = const AsyncValue.loading();

    await Future.delayed(const Duration(milliseconds: 2500));

    try {
      // upload to firestore
      await ref.read(resultRepositoryProvider).uploadUserResultToFirestore(userResult);
      // delete from memory
      await ref.read(resultRepositoryProvider).deleteUserResultFromMemory(userResult);
    } catch (error, stack) {
      // TODO: ERROR SHOWN TO USER
      print('FAILED TO UPLOAD...');
      print(error);
      state = AsyncError(error, stack);
    }

    state = const AsyncValue.data(null);
  }
}
