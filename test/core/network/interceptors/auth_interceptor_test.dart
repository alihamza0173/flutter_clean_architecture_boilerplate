import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth firebaseAuth;
  late AuthInterceptor interceptor;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    interceptor = AuthInterceptor(firebaseAuth: firebaseAuth);
  });

  Future<RequestOptions> runOnRequest() async {
    final options = RequestOptions(path: '/posts');
    await interceptor.onRequest(options, RequestInterceptorHandler());
    return options;
  }

  test('attaches a bearer token when a user is signed in', () async {
    final user = MockUser();
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => user.getIdToken()).thenAnswer((_) async => 'id-token');

    final options = await runOnRequest();

    expect(options.headers['Authorization'], 'Bearer id-token');
  });

  test('sends no Authorization header when signed out', () async {
    when(() => firebaseAuth.currentUser).thenReturn(null);

    final options = await runOnRequest();

    expect(options.headers.containsKey('Authorization'), isFalse);
  });

  test('proceeds unauthenticated when the token lookup throws', () async {
    final user = MockUser();
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => user.getIdToken()).thenThrow(Exception('network down'));

    final options = await runOnRequest();

    expect(options.headers.containsKey('Authorization'), isFalse);
  });
}
