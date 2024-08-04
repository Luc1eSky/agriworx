import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/possible_soils.dart';

part 'soil.freezed.dart';
part 'soil.g.dart';

/// class that holds all the info about the soil
@freezed
class Soil with _$Soil {
  const Soil._();
  const factory Soil({
    @SoilTypeConverter() required SoilType type,
    //required Color color,
    required String colorDescription,
    required String imageString,
    required String fertility,
    required String waterAbsorbance,
    required String characteristics,
  }) = _Soil;

  factory Soil.fromJson(Map<String, Object?> json) => _$SoilFromJson(json);

  factory Soil.fromGSheets(SoilType soilType) {
    final soil = possibleSoils.firstWhere((soil) => soil.type == soilType);
    return soil;
  }
  //
  // @override
  // factory Soil.fromJson(Map<String, Object?> json) {
  //   final soilTypeString = json['type'] as String;
  //   final soil = possibleSoils.firstWhere((soil) => soil.type.name == soilTypeString);
  //   return soil;
  // }
  //
  // Map<String, dynamic> _$SoilToJson(Soil instance) => {'type': type.name};

  //Map<String, dynamic> toJson() => {'type': type.name};
}

enum SoilType {
  grey,
  brown,
  black,
}

class SoilTypeConverter implements JsonConverter<SoilType, String> {
  const SoilTypeConverter();

  @override
  SoilType fromJson(String string) {
    final type = SoilType.values.firstWhere((value) => value.name == string);
    return type;
  }

  @override
  String toJson(SoilType soilType) => soilType.name;
}
