import 'package:validator/domain/entities/user.dart';

abstract class IUserService {
  Future<List<User>> getUsers();

  Future<User?> getUserByEmail(String email);

  Future<User> createUser(User user);

  Future<User> updateUserByEmail(String email, User updatedUser);

  Future<void> deleteUsers();

  Future<void> deleteUserByEmail(String email);
}
