import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/constants.dart';

double getItemWidth(double maxWidth) {
  return maxWidth /
      (maxNumberOfFertilizersPerWeek + (maxNumberOfFertilizersPerWeek + 1) * horizontalGapRatio);
}

/// helps to store Datetime object as String in memory
/// and read it vice versa
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String string) => DateTime.parse(string);

  @override
  String toJson(DateTime date) => date.toIso8601String();
}
