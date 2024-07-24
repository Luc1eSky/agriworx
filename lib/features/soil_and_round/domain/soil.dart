import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/possible_soils.dart';

part 'soil.freezed.dart';

/// class that holds all the info about the soil
@freezed
class Soil with _$Soil {
  const Soil._();
  const factory Soil({
    required SoilType type,
    //required Color color,
    required String colorDescription,
    required String imageString,
    required String fertility,
    required String waterAbsorbance,
    required String characteristics,
  }) = _Soil;

  factory Soil.fromJson(Map<String, Object?> json) {
    final soilTypeString = json['type'] as String;
    final soil = possibleSoils.firstWhere((soil) => soil.type.name == soilTypeString);
    return soil;
  }

  Map<String, dynamic> toJson() => {'type': type.name};
}

enum SoilType {
  grey,
  brown,
  black,
}
