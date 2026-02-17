import 'package:firebase_core/firebase_core.dart';
import '../../core/utils/logger.dart';

class FirebaseService {
  FirebaseService._();

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    AppLogger.info('Firebase initialized successfully', tag: 'FirebaseService');
  }
}
