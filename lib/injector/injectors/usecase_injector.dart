import 'package:get_it/get_it.dart';
import 'package:shreddit/injector/usecases/add_posts_usecase.dart';
import 'package:shreddit/injector/usecases/get_firebase_msg_usecase.dart';
import 'package:shreddit/injector/usecases/get_user_localdb_usecase.dart';
import 'package:shreddit/injector/usecases/delete_post_usecase.dart';
import 'package:shreddit/injector/usecases/dislike_usecase.dart';
import 'package:shreddit/injector/usecases/get_posts_usecase.dart';
import 'package:shreddit/injector/usecases/like_usecase.dart';
import 'package:shreddit/injector/usecases/log_in_usecase.dart';
import 'package:shreddit/injector/usecases/log_out_usecase.dart';
import 'package:shreddit/injector/usecases/permission_notify_usecase.dart';
import 'package:shreddit/injector/usecases/update_user_usecase.dart';
import 'package:shreddit/injector/usecases/registration_usecase.dart';

class UsecaseInjector {
  static void register() {
    GetIt.I.registerLazySingleton<GetPostsUsecase>(() => GetPostsUsecase());
    GetIt.I.registerLazySingleton<LogInUsecase>(() => LogInUsecase());
    GetIt.I.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase());
    GetIt.I.registerLazySingleton<AddPostsUsecase>(() => AddPostsUsecase());
    GetIt.I
        .registerLazySingleton<DeletePostsUsecase>(() => DeletePostsUsecase());
    GetIt.I.registerLazySingleton<LogOutUsecase>(() => LogOutUsecase());
    GetIt.I.registerLazySingleton<UpdateUserUsecase>(() => UpdateUserUsecase());
    GetIt.I.registerLazySingleton<LikeUsecase>(() => LikeUsecase());
    GetIt.I.registerLazySingleton<DislikeUsecase>(() => DislikeUsecase());
    GetIt.I.registerLazySingleton<GetUserLocalDBUsecase>(
        () => GetUserLocalDBUsecase());
    GetIt.I.registerLazySingleton<GetFirebaseMessagingUsecase>(
        () => GetFirebaseMessagingUsecase());
    GetIt.I.registerLazySingleton<PermissionNotifyUsecase>(
        () => PermissionNotifyUsecase());
  }
}
