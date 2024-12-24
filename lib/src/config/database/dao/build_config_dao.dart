import 'package:raptorx/src/config/database/app_database.dart';
import 'package:raptorx/src/features/settings/data/model/build_config_model.dart';
import 'package:sembast/sembast.dart';

class BuildConfigDao {
  static const String cacheDB = "build_config_db";
  static const String key = "wakil-raptor";
  final _cacheStore = stringMapStoreFactory.store(cacheDB);
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<BuildConfigModel?> addBuildConfigData(
      BuildConfigModel buildConfigModel) async {
    BuildConfigModel? result;
    try {
      var data = await _cacheStore
          .record(key)
          .put(await _db, buildConfigModel.toJson());
      result = BuildConfigModel.fromJson(data);
    } catch (e) {
      print("Caching adding error $e");
    }
    return result;
  }

  Future<BuildConfigModel?> readBuildConfigData() async {
    try {
      Map<String, dynamic> value =
          await _cacheStore.record(key).get(await _db) as Map<String, dynamic>;
      return BuildConfigModel.fromJson(value);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future deleteBuildConfigData(String cacheKey) async {
    try {
      await _cacheStore.record(cacheKey).delete(await _db);
    } catch (e) {
      print(e);
    }
  }

  deleteStore() async {
    try {
      await _cacheStore.delete(await _db);
    } catch (e) {}
  }
}
