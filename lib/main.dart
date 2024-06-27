import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/constants.dart';
import 'firebase_options.dart';
import 'game_screen.dart';
import 'local_storage/data/local_storage_repository.dart';

Future<void> setupEmulators() async {
  FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080); // host and port
}

void main() async {
  // do this before anything else
  WidgetsFlutterBinding.ensureInitialized();
  // initialize with default options from firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // wait to initialize shared preferences to get access to local memory
  // synchronously throughout the app
  final prefs = await SharedPreferences.getInstance();

  final containerWithOverrides = ProviderContainer(
    overrides: [
      // overwrite localStorageProvider and give it the SharedPrefs instance
      localStorageRepositoryProvider.overrideWithValue(LocalStorageRepository(prefs)),
    ],
  );

  // setup emulators after firebase was initialized but before the app runs
  if (useEmulators && kDebugMode) {
    await setupEmulators();
  }

  runApp(
    UncontrolledProviderScope(
      container: containerWithOverrides,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameScreen(), //const SoilSelectionScreen(),
    );
  }
}
