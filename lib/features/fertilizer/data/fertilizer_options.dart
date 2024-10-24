import 'package:agriworx/features/fertilizer/domain/fertilizer.dart';
import 'package:agriworx/style/color_palette.dart';
import 'package:flutter/material.dart';

import '../domain/amount.dart';
import '../domain/fertilizer_selection.dart';
import '../domain/unit.dart';

List<Fertilizer> availableFertilizers = [
  const Fertilizer(
    name: 'CAN',
    pricePerKilogramInUgx: 4000,
    imagePath: "assets/pictures/fertilizers/can.png",
    color: Colors.red,
    nitrogenPercentage: 0.27,
    phosphorusPercentage: 0,
    potassiumPercentage: 0,
    weightTampecoInGrams: 503,
    weightBlueCapInGrams: 7.3,
    weightGlassCapInGrams: 3.7,
  ),
  const Fertilizer(
    name: 'DAP',
    pricePerKilogramInUgx: 4200,
    imagePath: "assets/pictures/fertilizers/dap.png",
    color: Colors.blue,
    nitrogenPercentage: 0.18,
    phosphorusPercentage: 0.46,
    potassiumPercentage: 0,
    weightTampecoInGrams: 509,
    weightBlueCapInGrams: 6,
    weightGlassCapInGrams: 3.8,
  ),
  const Fertilizer(
    name: 'MOP',
    pricePerKilogramInUgx: 4500,
    imagePath: "assets/pictures/fertilizers/mop.png",
    color: Colors.green,
    nitrogenPercentage: 0,
    phosphorusPercentage: 0,
    potassiumPercentage: 0.6,
    weightTampecoInGrams: 532,
    weightBlueCapInGrams: 7.5,
    weightGlassCapInGrams: 3.9,
  ),
  const Fertilizer(
    name: 'NPK 17-17-17',
    pricePerKilogramInUgx: 4000,
    imagePath: "assets/pictures/fertilizers/npk17-17-17.png",
    color: Colors.orange,
    nitrogenPercentage: 0.17,
    phosphorusPercentage: 0.17,
    potassiumPercentage: 0.17,
    weightTampecoInGrams: 401,
    weightBlueCapInGrams: 5.5,
    weightGlassCapInGrams: 3.0,
  ),
  const Fertilizer(
    name: 'NPK 25-5-5',
    pricePerKilogramInUgx: 3600,
    imagePath: "assets/pictures/fertilizers/npk25-5-5.png",
    color: Colors.purple,
    nitrogenPercentage: 0.25,
    phosphorusPercentage: 0.05,
    potassiumPercentage: 0.05,
    weightTampecoInGrams: 484,
    weightBlueCapInGrams: 6.6,
    weightGlassCapInGrams: 3.2,
  ),
  const Fertilizer(
    name: 'UREA',
    pricePerKilogramInUgx: 3800,
    imagePath: "assets/pictures/fertilizers/urea.png",
    color: Colors.yellow,
    nitrogenPercentage: 0.46,
    phosphorusPercentage: 0,
    potassiumPercentage: 0,
    weightTampecoInGrams: 373,
    weightBlueCapInGrams: 5.3,
    weightGlassCapInGrams: 2.8,
  ),
  const Fertilizer(
    name: 'TSP',
    pricePerKilogramInUgx: 4000,
    imagePath: "assets/pictures/fertilizers/fertilizer_placeholder.png",
    color: Colors.teal,
    nitrogenPercentage: 0,
    phosphorusPercentage: 0.46,
    potassiumPercentage: 0,
    weightTampecoInGrams: 500,
    weightBlueCapInGrams: 7,
    weightGlassCapInGrams: 4,
  ),
  Fertilizer(
    name: 'YaraMila Winner',
    pricePerKilogramInUgx: 5000, // TODO: UPDATE
    imagePath: "assets/pictures/fertilizers/yaraMila_winner.png",
    color: ColorPalette.brandedFertilizerColor,
    nitrogenPercentage: 0.15,
    phosphorusPercentage: 0.09,
    potassiumPercentage: 0.20,
    weightTampecoInGrams: 500,
    weightBlueCapInGrams: 7.0,
    weightGlassCapInGrams: 4.1,
  ),
  Fertilizer(
    name: 'YaraLiva Nitrabor',
    pricePerKilogramInUgx: 5000, // TODO: UPDATE
    imagePath: "assets/pictures/fertilizers/yaraLiva_nitrabor.png",
    color: ColorPalette.brandedFertilizerColor,
    nitrogenPercentage: 0.15,
    phosphorusPercentage: 0,
    potassiumPercentage: 0,
    weightTampecoInGrams: 500,
    weightBlueCapInGrams: 7.5,
    weightGlassCapInGrams: 4.3,
  ),
  Fertilizer(
    name: 'YaraMila Power',
    pricePerKilogramInUgx: 5000, // TODO: UPDATE
    imagePath: "assets/pictures/fertilizers/yaraMila_power.png",
    color: ColorPalette.brandedFertilizerColor,
    nitrogenPercentage: 0.13,
    phosphorusPercentage: 0.24,
    potassiumPercentage: 0.12,
    weightTampecoInGrams: 500,
    weightBlueCapInGrams: 6.9,
    weightGlassCapInGrams: 3.8,
  ),
  Fertilizer(
    name: 'Grainpulse Tomato',
    pricePerKilogramInUgx: 5000, // TODO: UPDATE
    imagePath: "assets/pictures/fertilizers/grainpulse_tomato.png",
    color: ColorPalette.brandedFertilizerColor,
    nitrogenPercentage: 0.24,
    phosphorusPercentage: 0.16,
    potassiumPercentage: 0.14,
    weightTampecoInGrams: 500,
    weightBlueCapInGrams: 6.4,
    weightGlassCapInGrams: 3.8,
  ),
  Fertilizer(
    name: 'AMS',
    pricePerKilogramInUgx: 5000, // TODO: UPDATE
    imagePath: "assets/pictures/fertilizers/ammonia_sulphate.png",
    color: ColorPalette.brandedFertilizerColor,
    nitrogenPercentage: 0.21,
    phosphorusPercentage: 0,
    potassiumPercentage: 0,
    weightTampecoInGrams: 500,
    weightBlueCapInGrams: 7.7,
    weightGlassCapInGrams: 4.1,
  ),
];

// manure can only be added in one week, otherwise it's not available
const justManure = Fertilizer(
  name: 'MANURE',
  pricePerKilogramInUgx: 200,
  imagePath: "assets/pictures/fertilizers/manure.png",
  color: Colors.brown,
  nitrogenPercentage: 0.0,
  phosphorusPercentage: 0.0,
  potassiumPercentage: 0.0,
  weightTampecoInGrams: 349,
  weightBlueCapInGrams: 5.3,
  weightGlassCapInGrams: 4,
);

// a cup of manure is the only fertilizer selection in week 2
const aCupOfManure = FertilizerSelection(
  fertilizer: justManure,
  amount: Amount(count: 1, unit: Unit.tampeco),
  selectionWasCalculated: false,
);
