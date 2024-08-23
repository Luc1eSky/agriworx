import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/fertilizer/data/fertilizer_options.dart';
import 'package:agriworx/features/fertilizer/domain/amount.dart';
import 'package:agriworx/features/fertilizer/domain/fertilizer_selection.dart';
import 'package:agriworx/features/fertilizer/domain/unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwitchExample extends ConsumerStatefulWidget {
  const SwitchExample({super.key});

  @override
  ConsumerState<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends ConsumerState<SwitchExample> {
  bool _isToggled = false;
  // Function to call when the switch is turned on
  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
  @override
  Widget build(BuildContext context) {
    // Read the current value of the switch from the provider

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Manure'),
        Switch(
          thumbIcon: thumbIcon,
          value: _isToggled,
          activeColor: Colors.green,
          onChanged: !ref
                  .watch(fertilizerDataRepositoryProvider)
                  .canToggleManure
              ? null
              : (bool value) {
                  setState(() {
                    _isToggled = value;
                  });

                  if (value) {
                    ref
                        .read(fertilizerDataRepositoryProvider.notifier)
                        .addOneCupManure(
                            weekNumber: 1,
                            index: 0,
                            fertilizerSelection: const FertilizerSelection(
                                fertilizer: justManure,
                                amount: Amount(count: 1, unit: Unit.tampeco),
                                selectionWasCalculated: false));
                  } else {
                    ref
                        .read(fertilizerDataRepositoryProvider.notifier)
                        .removeOneCupManure(weekNumber: 1, index: 0);
                  }
                },
        ),
      ],
    );
  }
}
