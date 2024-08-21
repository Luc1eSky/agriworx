import 'package:agriworx/common_widgets/default_dialog.dart';
import 'package:agriworx/features/persons_involved/presentation/select_user_and_enumerator_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YieldDisplayDialog extends StatelessWidget {
  const YieldDisplayDialog({
    super.key,
    required this.expectedYield,
    required this.expectedReturn,
    required this.expectedProfit,
  });

  final double expectedYield;
  final double expectedReturn;
  final double expectedProfit;

  String getFormattedNumber(double number) {
    return NumberFormat('#,###').format(number);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: 'Results from Round',
      hasCloseButton: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expected Yield: ${getFormattedNumber(expectedYield)} kg',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Expected Return: ${getFormattedNumber(expectedReturn)} UGX',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Expected Profit: ${getFormattedNumber(expectedProfit)} UGX',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            const Text('includes random shocks'),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // move to game screen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SelectUserAndEnumeratorScreen()),
                    (Route<dynamic> route) => false, // This will remove all previous routes
                  );
                },
                child: const Text('Continue to next Round'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
