// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'unit.freezed.dart';
// part 'unit.g.dart';
//
// @freezed
// class Unit with _$Unit {
//   const factory Unit({
//     required String name,
//     required double weightInGrams,
//     String? imagePath,
//   }) = _Unit;
//
//   factory Unit.fromJson(Map<String, Object?> json) => _$UnitFromJson(json);
// }

enum Unit {
  tampeco,
  blueBottlecap,
  glassBottlecap,
  grams,
}

extension UnitExtension on Unit {
  // return name of asset image
  String get imageName {
    switch (this) {
      case Unit.tampeco:
        return 'assets/pictures/units/tampeco.png';
      case Unit.blueBottlecap:
        return 'assets/pictures/units/blue_bottle_cap.png';
      case Unit.glassBottlecap:
        return 'assets/pictures/units/glass_bottle_cap.png';
      case Unit.grams:
        return 'assets/pictures/units/scale_grams.png';
    }
  }

  // overwrite name of enum
  String get name {
    switch (this) {
      case Unit.tampeco:
        return 'Tampeco Cup';
      case Unit.blueBottlecap:
        return 'Blue Bottlecap';
      case Unit.glassBottlecap:
        return 'Glass Bottlecap';
      case Unit.grams:
        return 'Grams';
    }
  }
}
