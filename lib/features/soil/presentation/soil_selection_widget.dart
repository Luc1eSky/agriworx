import 'package:agriworx/features/soil/data/soil_repository.dart';
import 'package:agriworx/game_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/possible_soils.dart';

/// selection widget with carousel and selection button
class SoilSelectionWidget extends StatefulWidget {
  const SoilSelectionWidget({
    super.key,
    required this.aspectRatio,
  });

  final double aspectRatio;

  @override
  State<SoilSelectionWidget> createState() => _SoilSelectionWidgetState();
}

class _SoilSelectionWidgetState extends State<SoilSelectionWidget> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CarouselSlider(
              items: possibleSoilWidgets,
              options: CarouselOptions(
                aspectRatio: 1.0,
                viewportFraction: 0.75,
                initialPage: _selectedIndex,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                onPageChanged: (index, reason) {
                  _selectedIndex = index;
                },
                scrollDirection: Axis.horizontal,
                scrollPhysics: const BouncingScrollPhysics(),
                //clipBehavior: Clip.none,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: FittedBox(
              child: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () {
                      final selectedSoil = possibleSoils[_selectedIndex];
                      print('selected soil: $selectedSoil');
                      ref.read(soilRepositoryProvider.notifier).selectSoil(selectedSoil);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const GameScreen();
                          },
                        ),
                      );
                    },
                    child: const AutoSizeText(
                      'SELECT SOIL',
                      minFontSize: 0,
                    ),
                  );
                },
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
