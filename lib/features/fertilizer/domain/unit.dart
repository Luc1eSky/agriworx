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
}

extension UnitExtension on Unit {
  // return name of asset image
  String get imageName {
    switch (this) {
      case Unit.tampeco:
        return 'tampeco.jpg';
      case Unit.blueBottlecap:
        return 'blueBottlecap.jpg';
      case Unit.glassBottlecap:
        return 'glassBottlecap.jpg';
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
    }
  }
}
