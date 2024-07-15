/// captures all different states that can happen
/// between memory and database versions of the enumerator and user lists
enum ListStatus {
  noListInMemoryNoListInDatabase,
  noListInMemoryButListInDatabase,
  listInMemoryNoNewerListInDatabase,
  listInMemoryButNewerListInDatabase,
}

/// extension that returns a text that can be shown
extension TextExtension on ListStatus {
  String get text {
    switch (this) {
      case ListStatus.noListInMemoryNoListInDatabase:
        return 'No list in memory, no list found in database.';
      case ListStatus.noListInMemoryButListInDatabase:
        return 'No list in memory, but list found in database.';
      case ListStatus.listInMemoryNoNewerListInDatabase:
        return 'List in memory, no newer list found in database.';
      case ListStatus.listInMemoryButNewerListInDatabase:
        return 'List in memory and newer list found in database.';
    }
  }
}

/// getter that shows if a list is in memory
/// this is needed in order to know if experiment can be played
extension ListInMemoryExtension on ListStatus {
  bool get isInMemory {
    switch (this) {
      case ListStatus.noListInMemoryNoListInDatabase:
        return false;
      case ListStatus.noListInMemoryButListInDatabase:
        return false;
      case ListStatus.listInMemoryNoNewerListInDatabase:
        return true;
      case ListStatus.listInMemoryButNewerListInDatabase:
        return true;
    }
  }
}

/// getter that shows if there is a newer list available in database
/// this is needed in order to show a download button
extension NewerListExtension on ListStatus {
  bool get hasNewerList {
    switch (this) {
      case ListStatus.noListInMemoryNoListInDatabase:
        return false;
      case ListStatus.noListInMemoryButListInDatabase:
        return true;
      case ListStatus.listInMemoryNoNewerListInDatabase:
        return false;
      case ListStatus.listInMemoryButNewerListInDatabase:
        return true;
    }
  }
}
