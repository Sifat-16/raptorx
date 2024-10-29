import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:raptorx/src/config/database/dao/build_config_dao.dart';
import 'package:raptorx/src/features/auth/data/repositories/auth_repository_impl.dart';

final sl = GetIt.I;
final container = ProviderContainer();

setupService() async {
  sl.registerLazySingleton(() => AuthRepositoryImpl());
  sl.registerLazySingleton(() => BuildConfigDao());
}
