import 'package:flutter/material.dart';

class YieldButton extends StatelessWidget {
  const YieldButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('calculate yield');
      },
      child: const Text('YIELD'),
    );
  }
}
