import 'package:freezed_annotation/freezed_annotation.dart';

part 'soil.freezed.dart';
part 'soil.g.dart';

/// class that holds all the info about the soil
@freezed
class Soil with _$Soil {
  const factory Soil({
    required String name,
    //required Color color,
    required String colorDescription,
    required String imageString,
    required String fertility,
    required String waterAbsorbance,
    required String characteristics,
  }) = _Soil;

  factory Soil.fromJson(Map<String, Object?> json) => _$SoilFromJson(json);
}
