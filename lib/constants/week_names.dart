import 'constants.dart';

final List<String> weekNames = List.generate(numberOfWeeks, (index) {
  if (index == 0) {
    return 'pre';
  }
  if (index == 1) {
    return 'trans';
  }
  return 'week ${index - 1}';
});
