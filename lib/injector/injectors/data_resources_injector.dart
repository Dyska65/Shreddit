import 'package:get_it/get_it.dart';
import 'package:shreddit/network/api_manager.dart';
import 'package:shreddit/network/cloud_msg_manager.dart';
import 'package:shreddit/network/data_manager.dart';
import 'package:shreddit/network/firebase_manager.dart';

class DataResourcesInjector {
  static void register() {
    GetIt.I.registerLazySingleton<FirebaseManager>(() => FirebaseManagerImpl());
    GetIt.I.registerLazySingleton<DataManager>(() => DataManagerImpl());
    GetIt.I.registerLazySingleton<APIManager>(() => APIManagerImpl());
    GetIt.I.registerLazySingleton<CloudMessageManager>(
        () => CloudMessageManagerImpl());
  }
}
