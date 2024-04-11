import 'package:flutter/material.dart';

import '../domain/unit.dart';

class UnitWidget extends StatelessWidget {
  const UnitWidget({super.key, required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Text(unit.name),
      ),
    );
  }
}
