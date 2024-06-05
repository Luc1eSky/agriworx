import 'package:agriworx/features/soil/domain/soil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// list that holds all possible soils participants can choose from
const List<Soil> possibleSoils = [
  Soil(
    name: 'grey soil',
    colorDescription: 'grey to orange',
    imageString: "assets/pictures/grey_soil.png",
    fertility: 'low to moderate',
    waterAbsorbance: 'absorbs water quickly and dries quickly',
    characteristics: 'sandy but holds water',
  ),
  Soil(
    name: 'brown soil',
    colorDescription: 'reddish to deep brown',
    imageString: 'assets/pictures/brown_soil.png',
    fertility: 'fertile to very fertile',
    waterAbsorbance: 'absorbs water quickly and holds it for long',
    characteristics: 'friable, easy to work with, clay loam',
  ),
  Soil(
    name: 'black soil',
    colorDescription: 'black',
    imageString: 'assets/pictures/black_soil.png',
    fertility: 'very fertile',
    waterAbsorbance: 'absorbs water slowly but holds it for long',
    characteristics: 'very sticky when wet, cracking clays',
  ),
];

/// creates a list of widgets to display
List<Widget> possibleSoilWidgets = possibleSoils.map((soil) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      color: Colors.grey,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              soil.imageString,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: ListTile(
                  // title: AutoSizeText(
                  //   soil.name.toUpperCase(),
                  //   maxLines: 1,
                  //   minFontSize: 2,
                  //   maxFontSize: 50,
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  subtitle: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            soil.name.toUpperCase(),
                            maxLines: 1,
                            minFontSize: 2,
                            maxFontSize: 50,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AutoSizeText.rich(
                            TextSpan(children: [
                              const TextSpan(
                                text: '\u2022 fertility: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${soil.fertility}\n'),
                              const TextSpan(
                                text: '\u2022 water: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${soil.waterAbsorbance}\n'),
                              const TextSpan(
                                text: '\u2022 characteristics: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: soil.characteristics),
                            ]),
                            minFontSize: 2,
                            maxFontSize: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}).toList();
