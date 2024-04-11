import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
class Unit with _$Unit {
  const factory Unit({
    required String name,
    required double weightInGrams,
    String? imagePath,
  }) = _Unit;

  factory Unit.fromJson(Map<String, Object?> json) => _$UnitFromJson(json);
}

//
// enum Unit {
//   plate,
//   blueBottlecap,
//   cup,
// }
//
// extension UnitExtension on Unit {
//   double get weightInGrams {
//     switch (this) {
//       case Unit.plate:
//         return 200;
//       case Unit.blueBottlecap:
//         return 5;
//       case Unit.cup:
//         return 50;
//     }
//   }
//
//   String get name {
//     switch (this) {
//       case Unit.plate:
//         return 'Plate';
//       case Unit.blueBottlecap:
//         return 'Blue Bottlecap';
//       case Unit.cup:
//         return 'Cup';
//     }
//   }
// }
