import 'package:firebase_messaging/firebase_messaging.dart';
import '../../core/utils/logger.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission();
    AppLogger.info(
      'FCM permission: ${settings.authorizationStatus}',
      tag: 'FCM',
    );

    // Get token
    final token = await _messaging.getToken();
    AppLogger.info('FCM Token: $token', tag: 'FCM');

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      AppLogger.info('FCM Token refreshed: $newToken', tag: 'FCM');
      // TODO: Send new token to your server
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.info(
      'Foreground message: ${message.notification?.title}',
      tag: 'FCM',
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    AppLogger.info(
      'Message opened app: ${message.notification?.title}',
      tag: 'FCM',
    );
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
