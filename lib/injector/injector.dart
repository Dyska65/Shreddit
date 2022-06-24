import 'package:shreddit/injector/injectors/data_resources_injector.dart';
import 'package:shreddit/injector/injectors/repository_injector.dart';
import 'package:shreddit/injector/injectors/usecase_injector.dart';

class Injector {
  static void register() {
    DataResourcesInjector.register();
    RepositoryInjector.register();
    UsecaseInjector.register();
  }
}
