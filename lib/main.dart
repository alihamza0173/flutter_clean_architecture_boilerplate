import 'package:flutter/material.dart';
import 'app/app.dart';
import 'injection_container.dart';
import 'services/firebase/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.initialize();

  // Initialize dependencies
  await initDependencies();

  runApp(const App());
}
