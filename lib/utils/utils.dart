import '../constants/constants.dart';

double getItemWidth(double maxWidth) {
  return maxWidth /
      (maxNumberOfFertilizersPerWeek + (maxNumberOfFertilizersPerWeek + 1) * horizontalGapRatio);
}
