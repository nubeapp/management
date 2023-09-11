import 'package:get_it/get_it.dart';
import 'package:validator/domain/services/user_service_interface.dart';
import '../../config_test.dart';

class UserServiceConfigTest extends ConfigTest {
  late IUserService _userService;

  Future<IUserService> setUpDatabase() async {
    await super.setUpBaseDatabase();
    _userService = GetIt.instance<IUserService>();

    return _userService;
  }

  Future<void> cleanUpDatabase() async {
    await super.cleanUpBaseDatabase();
    await _userService.deleteUsers();
  }
}
