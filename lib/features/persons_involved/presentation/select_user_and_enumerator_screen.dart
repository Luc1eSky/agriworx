import 'package:agriworx/features/fertilizer/data/fertilizer_data_repository.dart';
import 'package:agriworx/features/persons_involved/enumerator/data/enumerator_repository.dart';
import 'package:agriworx/features/persons_involved/enumerator/domain/enumerator.dart';
import 'package:agriworx/features/persons_involved/user/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../soil_and_round/repository/soil_and_round_selection_screen.dart';
import '../enumerator/data/enumerator_list_repository.dart';
import '../user/data/user_list_repository.dart';
import '../user/domain/user.dart';

final _formKey = GlobalKey<FormState>();

class SelectUserAndEnumeratorScreen extends ConsumerStatefulWidget {
  const SelectUserAndEnumeratorScreen({super.key});

  @override
  ConsumerState<SelectUserAndEnumeratorScreen> createState() =>
      _SelectUserAndEnumeratorScreenState();
}

class _SelectUserAndEnumeratorScreenState extends ConsumerState<SelectUserAndEnumeratorScreen> {
  Enumerator? _selectedEnumerator;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _selectedEnumerator = ref.read(enumeratorRepositoryProvider);
    _selectedUser = ref.read(userRepositoryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final enumeratorList = ref.watch(enumeratorListRepositoryProvider);
    final userList = ref.watch(userListRepositoryProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Navigator.canPop(context)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.close),
            )
          : null,
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose enumerator:',
                  style: TextStyle(fontSize: 24),
                ),
                DropdownButtonFormField(
                  value: _selectedEnumerator,
                  decoration: const InputDecoration(hintText: 'please select'),
                  items: enumeratorList?.enumerators
                      .map(
                        (enumerator) => DropdownMenuItem(
                          value: enumerator,
                          child: Text('${enumerator.firstName} ${enumerator.lastName} , '
                              'uid:${enumerator.uid}'),
                        ),
                      )
                      .toList(),
                  onChanged: (newEnumerator) {
                    setState(() {
                      _selectedEnumerator = newEnumerator;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select enumerator';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48),
                const Text(
                  'Choose participant:',
                  style: TextStyle(fontSize: 24),
                ),
                DropdownButtonFormField(
                  value: _selectedUser,
                  decoration: const InputDecoration(hintText: 'please select'),
                  items: userList?.users
                      .map(
                        (user) => DropdownMenuItem(
                          value: user,
                          child: Text('${user.firstName} ${user.lastName} , '
                              'uid:${user.uid}'),
                        ),
                      )
                      .toList(),
                  onChanged: (newUser) {
                    setState(() {
                      _selectedUser = newUser;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select participant';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // when user is switched delete fertilizer data from game screen
                        if (_selectedUser != ref.read(userRepositoryProvider)) {
                          ref.read(fertilizerDataRepositoryProvider.notifier).deleteAllData();
                        }

                        // update current user and enumerator
                        await ref
                            .read(enumeratorRepositoryProvider.notifier)
                            .changeEnumerator(_selectedEnumerator!);
                        await ref.read(userRepositoryProvider.notifier).changeUser(_selectedUser!);

                        // move to game screen
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const SoilAndRoundSelectionScreen()),
                            (Route<dynamic> route) => false, // This will remove all previous routes
                          );
                        }
                      }
                    },
                    child: const Text('Start Experiment'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
