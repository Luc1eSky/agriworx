import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fertilizer.freezed.dart';
part 'fertilizer.g.dart';

@freezed
class Fertilizer with _$Fertilizer {
  // needed for methods and getters
  const Fertilizer._();
  const factory Fertilizer({
    required String name,
    required double nitrogenPercentage,
    required double phosphorusPercentage,
    required double potassiumPercentage,
    required double weightTampecoInGrams,
    required double weightBlueCapInGrams,
    required double weightGlassCapInGrams,
    required double pricePerKilogramInUgx,
    required String imagePath,
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) required Color color,
  }) = _Fertilizer;

  factory Fertilizer.fromJson(Map<String, Object?> json) => _$FertilizerFromJson(json);

  double get pricePerGramInUgx => pricePerKilogramInUgx / 1000;
}

Color _colorFromJson(dynamic colorValue) {
  return Color(colorValue as int);
}

int _colorToJson(Color color) {
  return color.value;
}
