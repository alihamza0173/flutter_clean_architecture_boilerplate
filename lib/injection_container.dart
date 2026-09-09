import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';
import 'core/network/dio_factory.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/domain/usecases/get_post_by_id_usecase.dart';
import 'features/posts/domain/usecases/get_posts_usecase.dart';
import 'features/posts/presentation/bloc/posts_bloc.dart';
import 'services/firebase/analytics_service.dart';
import 'services/firebase/crashlytics_service.dart';
import 'services/firebase/messaging_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ---------- BLoCs ----------
  sl.registerFactory(() => AuthBloc(signInUseCase: sl(), signUpUseCase: sl()));
  sl.registerFactory(
    () => PostsBloc(getPostsUseCase: sl(), getPostByIdUseCase: sl()),
  );

  // ---------- Use Cases ----------
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetPostByIdUseCase(sl()));

  // ---------- Repositories ----------
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  // ---------- Data Sources ----------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(apiClient: sl()),
  );

  // ---------- Services ----------
  sl.registerLazySingleton(() => AnalyticsService());
  sl.registerLazySingleton(() => CrashlyticsService());
  sl.registerLazySingleton(() => MessagingService());

  // ---------- Core ----------
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiClient>(
    () => DioApiClient(dio: sl(), networkInfo: sl()),
  );

  // ---------- External ----------
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<Dio>(() => DioFactory.create(firebaseAuth: sl()));
}
