import 'package:agriworx/features/persons_involved/presentation/select_user_and_enumerator_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YieldDisplayDialog extends StatelessWidget {
  const YieldDisplayDialog(
      {super.key,
      required this.expectedYield,
      required this.expectedReturn,
      required this.expectedProfit});

  final double expectedYield;
  final double expectedReturn;
  final double expectedProfit;
  @override
  Widget build(BuildContext context) {
    String getFormattedNumber(double number) {
      return NumberFormat('#,###').format(number);
    }

    // TODO: implement build
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Results from Round:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
              ElevatedButton(
                onPressed: () {
                  // move to game screen
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              const SelectUserAndEnumeratorScreen()),
                      (Route<dynamic> route) =>
                          false, // This will remove all previous routes
                    );
                  }
                },
                child: const Text('Continue to next Round'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
