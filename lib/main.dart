import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

import 'injection_container.dart';
import 'services/firebase/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Firebase.initializeApp(),
    FirebaseService.initialize(),
    initDependencies(),
  ]);

  runApp(const App());
}
