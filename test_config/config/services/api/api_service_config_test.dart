import 'package:get_it/get_it.dart';
import 'package:validator/domain/services/api_service_interface.dart';
import '../../config_test.dart';

class ApiServiceConfigTest extends ConfigTest {
  late IApiService _apiService;

  Future<IApiService> setUpDatabase() async {
    await super.setUpBaseDatabase();

    _apiService = GetIt.instance<IApiService>();

    return _apiService;
  }

  Future<void> cleanUpDatabase() async {
    await super.cleanUpBaseDatabase();
  }
}
