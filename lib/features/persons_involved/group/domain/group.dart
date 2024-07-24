import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../soil_and_round/domain/soil.dart';
import '../../../soil_and_round/domain/soil_and_round.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class Group with _$Group {
  const Group._();
  const factory Group({
    required int id,
    required String name,
    required List<SoilAndRound> targetRounds,
  }) = _Group;

  factory Group.fromJson(Map<String, Object?> json) => _$GroupFromJson(json);

  factory Group.fromGSheet(Map<String, String> json) {
    final blackSoilRounds =
        int.parse(json.entries.firstWhere((entry) => entry.key.startsWith('black')).value);
    final brownSoilRounds =
        int.parse(json.entries.firstWhere((entry) => entry.key.startsWith('brown')).value);
    final greySoilRounds =
        int.parse(json.entries.firstWhere((entry) => entry.key.startsWith('grey')).value);

    final listOfSoilsAndRounds = [
      SoilAndRound(
        soil: Soil.fromJson({'type': SoilType.black.name}),
        round: blackSoilRounds,
      ),
      SoilAndRound(
        soil: Soil.fromJson({'type': SoilType.brown.name}),
        round: brownSoilRounds,
      ),
      SoilAndRound(
        soil: Soil.fromJson({'type': SoilType.grey.name}),
        round: greySoilRounds,
      ),
    ];

    final id = json['id'];
    final name = json['name'];

    if (id == null || id == '') {
      throw Exception('Could not find "id" for group!');
    }
    if (name == null || name == '') {
      throw Exception('Could not find "name" for enumerator with id $id!');
    }

    return Group(
      id: int.parse(id),
      name: name,
      targetRounds: listOfSoilsAndRounds,
    );
  }
}
