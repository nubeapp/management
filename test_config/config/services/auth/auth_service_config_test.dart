import 'package:get_it/get_it.dart';
import 'package:validator/domain/services/auth_service_interface.dart';
import '../../config_test.dart';

class AuthServiceConfigTest extends ConfigTest {
  late IAuthService _authService;

  Future<IAuthService> setUpDatabase() async {
    await super.setUpBaseDatabase();

    _authService = GetIt.instance<IAuthService>();

    return _authService;
  }

  Future<void> cleanUpDatabase() async {
    await super.cleanUpBaseDatabase();
  }
}
