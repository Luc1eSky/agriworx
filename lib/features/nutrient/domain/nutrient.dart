import 'dart:ui';

import 'package:agriworx/style/color_palette.dart';

enum Nutrient {
  nitrogen,
  phosphorus,
  potassium,
}

extension NutrientExtension on Nutrient {
  String get symbol {
    switch (this) {
      case Nutrient.nitrogen:
        return 'N';
      case Nutrient.phosphorus:
        return 'P';
      case Nutrient.potassium:
        return 'K';
    }
  }

  double get scalingFactor {
    switch (this) {
      case Nutrient.nitrogen:
        return 1.0;
      case Nutrient.phosphorus:
        return 0.44;
      case Nutrient.potassium:
        return 0.83;
    }
  }

  Color get color {
    switch (this) {
      case Nutrient.nitrogen:
        return ColorPalette.nitrogenBar;
      case Nutrient.phosphorus:
        return ColorPalette.phosphorusBar;
      case Nutrient.potassium:
        return ColorPalette.potassiumBar;
    }
  }
}
