import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class PinDialog extends StatefulWidget {
  const PinDialog({super.key});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  String pinCode = '';

  void addNumberToPin(int number) {
    if (pinCode.length < 4) {
      pinCode += number.toString();
      setState(() {});
    }
  }

  void deleteLastNumber() {
    if (pinCode.isNotEmpty) {
      pinCode = pinCode.substring(0, pinCode.length - 1);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 360,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 75,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        heightFactor: 0.6,
                        child: FittedBox(
                          child: Text(
                            'Enumerator Unlock',
                            style: TextStyle(fontSize: 100),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FittedBox(
                            child: Text(
                              pinCode,
                              style: const TextStyle(fontSize: 100),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        //color: Colors.green,
                        //height: 400,
                        child: FractionallySizedBox(
                          //widthFactor: 0.9,
                          //heightFactor: 0.9,
                          child: GridView.count(
                            childAspectRatio: 1.0,
                            crossAxisCount: 3,
                            //mainAxisSpacing: 10,
                            //crossAxisSpacing: 10,
                            children: List.generate(12, (index) {
                              int number = index + 1;

                              if (number == 10) {
                                return PinButton(
                                  number: number,
                                  backgroundColor: Colors.red,
                                  onPressedFunction: () => deleteLastNumber(),
                                  child: const Icon(
                                    Icons.backspace_outlined,
                                    size: 40,
                                  ),
                                );
                              }

                              if (number == 11) {
                                number = 0;
                              }

                              if (number == 12) {
                                return PinButton(
                                  number: number,
                                  backgroundColor: Colors.green,
                                  onPressedFunction: () {
                                    if (pinCode == unlockPin) {
                                      Navigator.of(context).pop(true);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.check,
                                    size: 40,
                                  ),
                                );
                              }

                              return PinButton(
                                number: number,
                                backgroundColor: Colors.blueGrey,
                                onPressedFunction: () => addNumberToPin(number),
                                child: Text(
                                  number.toString(),
                                  style: const TextStyle(fontSize: 100),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    //   DefaultDialog(
    //   title: 'Enter PIN',
    //   child: Column(
    //     children: [
    //       ElevatedButton(
    //         onPressed: () {
    //           Navigator.of(context).pop(false);
    //         },
    //         child: const Text('CLOSE'),
    //       ),
    //       ElevatedButton(
    //         onPressed: () {
    //           Navigator.of(context).pop(true);
    //         },
    //         child: const Text('CORRECT'),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class PinButton extends StatelessWidget {
  const PinButton({
    super.key,
    required this.number,
    required this.child,
    required this.backgroundColor,
    required this.onPressedFunction,
  });

  final int number;
  final Widget child;
  final Color backgroundColor;
  final VoidCallback onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressedFunction,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FittedBox(child: child),
        ),
      ),
    );
  }
}
