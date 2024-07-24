import 'package:gsheets/gsheets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../environment/env.dart';
import '../../persons_involved/enumerator/domain/enumerator.dart';
import '../../persons_involved/group/domain/group.dart';
import '../../persons_involved/user/domain/user.dart';

part 'google_sheets_repository.g.dart';

enum VersionState {
  upToDate,
  newVersionAvailable,
  noConnection,
}

/// repository that holds everything that has to do
/// with storing and accessing data locally
class GoogleSheetsRepository {
  GoogleSheetsRepository(this.gSheets);
  final GSheets gSheets;

  Future<VersionState> compareVersions(DateTime? lastEditedOnMemory) async {
    // fetch spreadsheet by its id
    Spreadsheet spreadsheet;
    try {
      spreadsheet = await gSheets.spreadsheet(_spreadsheetId);
    } catch (error) {
      return VersionState.noConnection;
    }
    // get version spreadsheet
    var versionSheet = spreadsheet.worksheetByTitle('version');
    if (versionSheet == null) {
      throw Exception('Could not find "version" sheet!');
    }
    // get version from sheet
    final lastEditedOnString = await versionSheet.values.value(row: 1, column: 2);
    final lastEditedOnSheets = _convertSheetsStringToDateTime(lastEditedOnString);

    // up to date (same DateTime in memory as from Sheets)
    if (lastEditedOnMemory != null && lastEditedOnMemory.isAtSameMomentAs(lastEditedOnSheets)) {
      return VersionState.upToDate;
    }
    // otherwise there is a new version available
    return VersionState.newVersionAvailable;
  }

  // checks if newer version is available online (Google Sheets)
  // and downloads enumerator and user lists as well as newest date
  // and stores it in local memory
  Future<({List<User> users, List<Enumerator> enumerators, DateTime lastEditedOn})?> downloadLists(
      DateTime? lastEditedOnMemory) async {
    // fetch spreadsheet by its id
    Spreadsheet spreadsheet;
    try {
      spreadsheet = await gSheets.spreadsheet(_spreadsheetId);
    } catch (error) {
      throw Exception('Could not connect to Sheet!');
    }

    // get different worksheets
    var userSheet = spreadsheet.worksheetByTitle('users');
    var enumeratorSheet = spreadsheet.worksheetByTitle('enumerators');
    var groupSheet = spreadsheet.worksheetByTitle('groups');
    var versionSheet = spreadsheet.worksheetByTitle('version');

    // check if all sheets exists
    if (userSheet == null) {
      throw Exception('Could not find "users" sheet!');
    }
    if (enumeratorSheet == null) {
      throw Exception('Could not find "enumerators" sheet!');
    }
    if (groupSheet == null) {
      throw Exception('Could not find "groups" sheet!');
    }
    if (versionSheet == null) {
      throw Exception('Could not find "version" sheet!');
    }

    // 1. CHECKING VERSION
    final lastEditedOnString = await versionSheet.values.value(row: 1, column: 2);
    final lastEditedOnSheets = _convertSheetsStringToDateTime(lastEditedOnString);

    // up to date (same DateTime in memory as from Sheets)
    if (lastEditedOnMemory != null && lastEditedOnMemory.isAtSameMomentAs(lastEditedOnSheets)) {
      return null;
    }

    // 2. ENUMERATOR DATA
    final allEnumeratorRows = await enumeratorSheet.values.map.allRows();
    if (allEnumeratorRows == null) {
      throw Exception('Could not get rows from sheet "enumerators"!');
    }
    final enumerators = allEnumeratorRows.map((json) => Enumerator.fromGSheets(json)).toList();

    // 3. GROUP DATA
    final allGroupRows = await groupSheet.values.map.allRows();
    if (allGroupRows == null) {
      throw Exception('Could not get rows from sheet "groups"!');
    }
    final groups = allGroupRows.map((json) => Group.fromGSheet(json)).toList();

    // 4. USER DATA
    final allUserRows = await userSheet.values.map.allRows();
    if (allUserRows == null) {
      throw Exception('Could not get rows from sheet "users"!');
    }

    final users = allUserRows.map((json) {
      print(json);
      final uid = json['uid'];
      final firstName = json['firstName'];
      final lastName = json['lastName'];
      final groupId = json['groupId'];

      if (uid == null || uid == '') {
        throw Exception('Could not find "uid" for user!');
      }
      if (firstName == null || firstName == '') {
        throw Exception('Could not find "firstName" for user with uid $uid!');
      }
      if (lastName == null || lastName == '') {
        throw Exception('Could not find "lastName" for user with uid $uid!');
      }
      if (groupId == null || groupId == '') {
        throw Exception('Could not find "groupId" for user with uid $uid!');
      }
      final groupIdInt = int.parse(groupId);
      final userGroup = groups.firstWhere((group) => group.id == groupIdInt);

      return User(uid: uid, firstName: firstName, lastName: lastName, group: userGroup);
    }).toList();

    // 5. RETURN USER AND ENUMERATOR LISTS
    return (users: users, enumerators: enumerators, lastEditedOn: lastEditedOnSheets);
  }
}

@riverpod
GoogleSheetsRepository googleSheetsRepository(GoogleSheetsRepositoryRef ref) {
  return GoogleSheetsRepository(GSheets(_credentials));
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
