enum Nutrient {
  nitrogen,
  phosphorus,
  potassium,
}

extension NutrientExtension on Nutrient {
  String get symbol {
    // return name of asset image
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
    // return name of asset image
    switch (this) {
      case Nutrient.nitrogen:
        return 1.0;
      case Nutrient.phosphorus:
        return 0.44;
      case Nutrient.potassium:
        return 0.83;
    }
  }
}
