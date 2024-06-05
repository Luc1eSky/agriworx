import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../style/color_palette.dart';
import '../domain/amount.dart';

class AmountWidget extends StatelessWidget {
  const AmountWidget({
    super.key,
    required this.itemWidth,
    required this.amount,
  });

  final double itemWidth;
  final Amount? amount;

  @override
  Widget build(BuildContext context) {
    final a = amount;
    return a == null
        ? Container(
            height: amountWidgetHeightRatio * itemWidth,
            color: ColorPalette.emptySpace,
          )
        : Container(
            height: amountWidgetHeightRatio * itemWidth,
            color: Colors.green,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      a.count.toString(),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: FittedBox(
                      child: Icon(
                        Icons.close,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      a.unit.name,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
