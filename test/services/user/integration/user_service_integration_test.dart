import 'package:flutter_test/flutter_test.dart';
import 'package:validator/domain/entities/user.dart';
import 'package:validator/domain/services/user_service_interface.dart';

import '../../../../test_config/config/services/user/user_service_config_test.dart';

void main() {
  UserServiceConfigTest userConfig = UserServiceConfigTest();
  late IUserService userService;

  setUpAll(() async {
    userService = await userConfig.setUpDatabase();
  });

  tearDownAll(() async {
    await userConfig.cleanUpDatabase();
  });

  group('UserService Integration Tests', () {
    test('Get all users', () async {
      final users = await userService.getUsers();
      expect(users, isA<List<User>>());
      expect(users.length, equals(1));
      expect(users.first.email, 'test@test.com');
      expect(users.first.name, 'test');
      expect(users.first.surname, 'test');
    });

    test('Get user by Email', () async {
      const mockEmail = 'test@test.com';
      final user = await userService.getUserByEmail(mockEmail);
      expect(user!, isA<User>());
      expect(user.name, 'test');
      expect(user.surname, 'test');
    });

    test('Create user', () async {
      const mockUser = User(email: 'mock@mock.com', name: 'mock', surname: 'mock', password: 'mockpassword');
      final usersBefore = await userService.getUsers();
      await userService.createUser(mockUser);
      final usersAfter = await userService.getUsers();
      expect(usersBefore.length + 1, usersAfter.length);

      await userService.deleteUserByEmail('mock@mock.com');
    });

    test('Update user by Email', () async {
      const User mockUserUpdated = User(email: 'test@test.com', name: 'test updated', surname: 'test updated', password: 'testpassword updated');
      final userBefore = await userService.getUserByEmail('test@test.com');
      await userService.updateUserByEmail(mockUserUpdated.email, mockUserUpdated);
      final userAfter = await userService.getUserByEmail('test@test.com');
      expect(userBefore!.name, isNot(userAfter!.name));
      expect(userBefore.surname, isNot(userAfter.surname));
    });

    test('Delete user by Email', () async {
      const mockUser = User(email: 'mock@mock.com', name: 'mock', surname: 'mock', password: 'mockpassword');
      User user = await userService.createUser(mockUser);
      final usersBefore = await userService.getUsers();
      await userService.deleteUserByEmail(user.email);
      final usersAfter = await userService.getUsers();
      expect(usersBefore.length - 1, usersAfter.length);
    });

    test('Delete users', () async {
      await userService.deleteUsers();
      final users = await userService.getUsers();
      expect(users.length, equals(0));
    });
  });
}
