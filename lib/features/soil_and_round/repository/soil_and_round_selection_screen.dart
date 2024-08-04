import 'dart:math';

import 'package:agriworx/features/persons_involved/user/data/user_repository.dart';
import 'package:agriworx/features/result/data/result_repository.dart';
import 'package:agriworx/features/soil_and_round/data/possible_soils.dart';
import 'package:agriworx/features/soil_and_round/data/soil_and_round_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../game_screen.dart';
import '../../fertilizer/data/fertilizer_data_repository.dart';
import '../../result/domain/round_result.dart';
import '../domain/soil.dart';
import '../domain/soil_and_round.dart';

final _formKey = GlobalKey<FormState>();

class SoilAndRoundSelectionScreen extends ConsumerStatefulWidget {
  const SoilAndRoundSelectionScreen({super.key});

  @override
  ConsumerState<SoilAndRoundSelectionScreen> createState() => _SoilAndRoundSelectionScreenState();
}

class _SoilAndRoundSelectionScreenState extends ConsumerState<SoilAndRoundSelectionScreen> {
  SoilType? _selectedSoilType;
  int? _selectedRound;
  RoundResult? _selectedResult;
  bool _roundFromScratchSelected = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userRepositoryProvider);
    final targetRounds = currentUser!.group.targetRounds;
    final userResult = ref.read(resultRepositoryProvider).loadUserResultFromMemory(currentUser);
    final roundResultsOfUser = userResult?.roundResults ?? [];
    return Scaffold(
      body: Container(
        color: Colors.yellow,
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select Soil and Round'),
                const SizedBox(height: 24),
                ...targetRounds.map((soilAndRound) {
                  final targetRoundCount = soilAndRound.round;
                  if (targetRoundCount == 0) {
                    return const SizedBox();
                  }

                  final soilType = soilAndRound.soil.type;
                  final soilTypeString =
                      soilType.name[0].toUpperCase() + soilType.name.substring(1);

                  final resultsOfSoilType = roundResultsOfUser
                      .where((result) => result.soilAndRound.soil.type == soilType)
                      .toList();

                  final soilTypeResultCount = resultsOfSoilType.length;
                  final soilRoundFinished = soilTypeResultCount == targetRoundCount;
                  return ChoiceChip(
                    onSelected: soilRoundFinished
                        ? null
                        : (bool selected) {
                            setState(() {
                              _selectedSoilType = soilType;
                              _selectedRound = soilTypeResultCount + 1;
                            });
                          },
                    label: Text('$soilTypeString Soil - Round '
                        '${min(soilTypeResultCount + 1, targetRoundCount)}/$targetRoundCount'),
                    selected: _selectedSoilType == soilType,
                  );
                }),
                const SizedBox(height: 48),
                const Text('New or from saved result'),
                const SizedBox(height: 24),
                ChoiceChip(
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedResult = null;
                      _roundFromScratchSelected = true;
                    });
                  },
                  label: const Text('new'),
                  selected: _roundFromScratchSelected,
                ),
                ...roundResultsOfUser.map(
                  (result) => ChoiceChip(
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedResult = result;
                        _roundFromScratchSelected = false;
                      });
                    },
                    label: Text(
                        '${result.soilAndRound.soil.type.name} Soil - Round ${result.soilAndRound.round}'),
                    selected: _selectedResult == result,
                  ),
                ),
                const SizedBox(height: 48),
                if (_selectedSoilType != null &&
                    _selectedRound != null &&
                    (_selectedResult != null || _roundFromScratchSelected == true))
                  ElevatedButton(
                    onPressed: () async {
                      // create Soil from SoilType
                      final selectedSoil =
                          possibleSoils.firstWhere((soil) => soil.type == _selectedSoilType);
                      final selectedSoilAndRound = SoilAndRound(
                        soil: selectedSoil,
                        round: _selectedRound!,
                      );

                      // set selected SoilAndRound
                      await ref
                          .read(soilAndRoundRepositoryProvider.notifier)
                          .changeSoilAndRound(selectedSoilAndRound);

                      // if new round from scratch was selected delete current fertilizer data
                      if (_roundFromScratchSelected) {
                        await ref.read(fertilizerDataRepositoryProvider.notifier).deleteAllData();
                      }

                      // load result if used as basis
                      if (_selectedResult != null) {
                        await ref
                            .read(fertilizerDataRepositoryProvider.notifier)
                            .loadFertilizerDataFromSavedResult(_selectedResult!.fertilizerData);
                      }
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const GameScreen()));
                      }
                    },
                    child: const Text('START'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
