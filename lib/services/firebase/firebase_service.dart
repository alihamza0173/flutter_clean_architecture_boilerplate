import 'package:firebase_core/firebase_core.dart';
import '../../core/utils/logger.dart';
import '../../firebase_options.dart';

class FirebaseService {
  FirebaseService._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('Firebase initialized successfully', tag: 'FirebaseService');
  }
}
