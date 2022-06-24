import 'package:get_it/get_it.dart';
import 'package:shreddit/repositories/firebase_message_repository.dart';
import 'package:shreddit/repositories/local_data_repository.dart';
import 'package:shreddit/repositories/posts_repository.dart';
import 'package:shreddit/repositories/authentication_repository.dart';

class RepositoryInjector {
  static void register() {
    GetIt.I.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl());
    GetIt.I.registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl());
    GetIt.I.registerLazySingleton<LocalDataRepository>(
        () => LocalDataRepositoryImpl());
    GetIt.I.registerLazySingleton<FirebaseMessageRepository>(
        () => FirebaseMessageRepositoryImpl());
  }
}
