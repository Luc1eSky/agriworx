import 'package:flutter/material.dart';

const int itemCount = 3;
const double gapRatio = 0.1;

const double vertGapRatio = 0.1;
const double quantityFieldHeightRatio = 0.5;

List<Widget> leadingWidgets = List.generate(10, (index) {
  if (index == 0) {
    return const Text('pre');
  }
  if (index == 1) {
    return const Text('trans');
  }
  return Text('week ${(index - 1).toString()}');
});

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agriworks Test Version'),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Center(
                  child: ListView.builder(
                    itemCount: leadingWidgets.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                          minVerticalPadding: 10.0,
                          subtitle: Row(
                            children: [
                              Container(
                                width: 80,
                                color: Colors.yellow,
                                child: Center(
                                  child: leadingWidgets[index],
                                ),
                              ),
                              Expanded(
                                child: LayoutBuilder(builder: (context, constraints) {
                                  final maxWidth = constraints.maxWidth;

                                  final itemWidth =
                                      maxWidth / (itemCount + (itemCount + 1) * gapRatio);

                                  final aspectRatio = itemWidth /
                                      (itemWidth +
                                          vertGapRatio * itemWidth +
                                          quantityFieldHeightRatio * itemWidth);

                                  final itemList = List.generate(
                                    itemCount,
                                        (index) => SizedBox(
                                      width: itemWidth,
                                      child: AspectRatio(
                                        aspectRatio: aspectRatio,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 1.0,
                                              child: Container(color: Colors.purple),
                                            ),
                                            Container(
                                              height: quantityFieldHeightRatio * itemWidth,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );

                                  print(itemWidth);
                                  return Container(
                                    //color: Colors.orange,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: itemList,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
