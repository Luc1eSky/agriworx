import 'package:agriworx/features/soil/presentation/soil_selection_widget.dart';
import 'package:flutter/material.dart';

const double minWidthSoilSelectionWidget = 400;
const double maxWidthSoilSelectionWidget = 700;
const double aspectRatioSoilSelectionWidget = 4 / 5;

/// screen that allows the participant to pick from a variety of soil types
class SoilSelectionScreen extends StatelessWidget {
  const SoilSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blueGrey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: minWidthSoilSelectionWidget,
                  maxWidth: maxWidthSoilSelectionWidget,
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return constraints.maxHeight <=
                          minWidthSoilSelectionWidget / aspectRatioSoilSelectionWidget
                      ? const SingleChildScrollView(
                          child: SizedBox(
                            width: minWidthSoilSelectionWidget,
                            child: SoilSelectionWidget(
                              aspectRatio: aspectRatioSoilSelectionWidget,
                            ),
                          ),
                        )
                      : const SoilSelectionWidget(
                          aspectRatio: aspectRatioSoilSelectionWidget,
                        );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
