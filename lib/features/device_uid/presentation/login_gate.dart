import 'package:agriworx/features/device_uid/data/get_device_code_provider.dart';
import 'package:agriworx/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginGate extends ConsumerWidget {
  const LoginGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get future provider value
    final deviceUid = ref.watch(getDeviceCodeProvider);
    return deviceUid.when(
      data: (data) => const GameScreen(),
      error: (error, stack) => ErrorScreen(errorMessage: error.toString()),
      loading: () => Container(color: Colors.blue),
    );

    //const GameScreen();
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({required this.errorMessage, super.key});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text(errorMessage),
      ),
    );
  }
}
