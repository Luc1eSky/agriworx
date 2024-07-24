import 'package:agriworx/features/google_sheets/data/google_sheets_repository.dart';
import 'package:agriworx/features/persons_involved/data/lists_updated_on_repository.dart';
import 'package:agriworx/features/persons_involved/enumerator/data/enumerator_list_repository.dart';
import 'package:agriworx/features/persons_involved/enumerator/domain/enumerator_list.dart';
import 'package:agriworx/features/persons_involved/user/data/user_list_repository.dart';
import 'package:agriworx/features/persons_involved/user/domain/user_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../environment/env.dart';
import '../../persons_involved/data/checking_versions_provider.dart';

part 'game_mode_selection_screen_controller.g.dart';

@riverpod
class GameModeSelectionScreenController extends _$GameModeSelectionScreenController {
  @override
  Future<void> build() async {
    // nothing to do
  }

  /// check if new version exists and if so,
  /// download enumerator, user, and group info from Google Sheets
  Future<void> checkAndDownloadListsFromSheets() async {
    // set async state to loading
    state = const AsyncValue.loading();

    try {
      // give UI time to update
      await Future.delayed(const Duration(milliseconds: 500));

      // get version from memory
      final lastEditedOnMemory = ref.read(listsUpdatedOnRepositoryProvider);

      // download lists
      final userAndEnumeratorLists =
          await ref.read(googleSheetsRepositoryProvider).downloadLists(lastEditedOnMemory);

      if (userAndEnumeratorLists == null) {
        // TODO: SHOW IF LIST WAS UPDATED
        state = const AsyncValue.data(null);
        return;
      }

      // get user and enumerator lists and date they were changed on
      final users = userAndEnumeratorLists.users;
      final enumerators = userAndEnumeratorLists.enumerators;
      final lastEditedOnSheets = userAndEnumeratorLists.lastEditedOn;

      print('users: $users');
      print('enumerators: $enumerators');
      print('lastEditedOnSheets: $lastEditedOnSheets');

      // save user end enumerator data
      await ref.read(userListRepositoryProvider.notifier).saveNewUserList(UserList(users: users));
      await ref
          .read(enumeratorListRepositoryProvider.notifier)
          .saveNewEnumeratorList(EnumeratorList(enumerators: enumerators));

      // save the date the new data was changed on
      ref.read(listsUpdatedOnRepositoryProvider.notifier).changeDateTime(lastEditedOnSheets);

      // outdated (no or older DateTime in Memory than from Sheets)
    } catch (error, stack) {
      // set state to AsyncError
      print(error);
      state = AsyncError(error, stack);
    }
    // invalidate (aka. refresh) the current state of the loading provider.
    // this leads to an update on the list status for enumerator and user list
    // as they should now be downloaded and in memory. So the UI can update
    // accordingly (not showing the download buttons anymore, or allowing to start
    // an experiment)
    ref.invalidate(checkingVersionsProvider);
    state = const AsyncValue.data(null);
  }

//   /// download enumerator or user list
//   Future<void> downloadListAndRefresh({required bool isUser}) async {
//     // set async state to loading
//     state = const AsyncValue.loading();
//
//     try {
//       // get enumerator or user collection ref
//       if (isUser) {
//         //  download user list
//         await ref.read(userListRepositoryProvider.notifier).downloadUserList();
//       } else {
//         //  download enumerator list
//         await ref.read(enumeratorListRepositoryProvider.notifier).downloadEnumeratorList();
//       }
//     } catch (error, stack) {
//       // set state to AsyncError
//       state = AsyncError(error, stack);
//     }
//     // invalidate (aka. refresh) the current state of the loading provider.
//     // this leads to an update on the list status for enumerator and user list
//     // as they should now be downloaded and in memory. So the UI can update
//     // accordingly (not showing the download buttons anymore, or allowing to start
//     // an experiment)
//     ref.invalidate(checkingVersionsProvider);
//     state = const AsyncValue.data(null);
//   }
}

/// helper function to convert date string (number as String) vom Google Sheets
/// to DateTime and adjust to local time
DateTime _convertSheetsStringToDateTime(String dateAsString) {
  final dateAsDouble = double.parse(dateAsString);
  final dateTime = DateTime(1899, 12, 30)
      .add(Duration(milliseconds: (dateAsDouble * Duration.millisecondsPerDay).toInt()));
  final adjustedDateTime = dateTime.toLocal().subtract(const Duration(hours: 1));
  return adjustedDateTime;
}

const _credentials_1 = r'''
{
  "type": "service_account",
  "project_id": "agriworks-70402",
  "private_key_id": "62f961c6eeaf52b1f0d3fbd7cce5c531d37858e9",
''';

final _private_key = '  "private_key": "${Env.googleSheetsApiKey}",\n';

const _credentials_2 = r'''
  "client_email": "gsheets@agriworks-70402.iam.gserviceaccount.com",
  "client_id": "113655703359412177721",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40agriworks-70402.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

// credentials and spreadsheet ID to connect to Google Sheet
final _credentials = _credentials_1 + _private_key + _credentials_2;
const _spreadsheetId = '1JeyA-KAbPqnjxstz3jlkr3R-2PRGh6HsktYGch3Jb8k';
