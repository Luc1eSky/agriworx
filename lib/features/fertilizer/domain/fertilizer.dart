import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fertilizer.freezed.dart';
part 'fertilizer.g.dart';

@freezed
class Fertilizer with _$Fertilizer {
  const factory Fertilizer({
    required String name,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) required Color color,
    String? imagePath,
  }) = _Fertilizer;

  factory Fertilizer.fromJson(Map<String, Object?> json) => _$FertilizerFromJson(json);
}

Color _colorFromJson(dynamic colorValue) {
  return Color(colorValue as int);
}

int _colorToJson(Color color) {
  return color.value;
}
