import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:validator/config/app_config.dart';
import 'package:validator/domain/entities/user.dart';
import 'package:validator/domain/services/user_service_interface.dart';
import 'package:validator/infrastructure/services/user_service.dart';

import '../../../mocks/mock_objects.dart';
import '../../../mocks/mock_responses.dart';
import 'user_service_unit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late IUserService userService;
  const String API_BASE_URL = 'http://$LOCALHOST:8000/users';

  group('UserService', () {
    group('getUsers', () {
      test('returns a list of users', () async {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer((_) async => http.Response(json.encode(mockUserListResponse), 200));

        final users = await userService.getUsers();

        expect(users, isA<List<User>>());
        expect(users.length, equals(2));
        expect(users[0].id, equals(1));
        expect(users[1].id, equals(2));
        expect(users[0].email, 'johndoe@example.com');
        expect(users[1].email, 'janesmith@example.com');
        expect(users[0].name, 'John');
        expect(users[1].name, 'Jane');
        expect(users[0].surname, 'Doe');
        expect(users[1].surname, 'Smith');

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);

        // Use Mockito to return an unsuccessful response when it calls the
        // provided http.Client.
        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await userService.getUsers(), throwsException);

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });
    });

    group('getUserByEmail', () {
      test('returns a user by specified email', () async {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);
        const String mockEmail = 'johndoe@example.com';

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockEmail'))).thenAnswer((_) async => http.Response(json.encode(mockUserResponse), 200));

        final user = await userService.getUserByEmail(mockEmail);

        expect(user, isA<User>());
        expect(user!.id, equals(1));
        expect(user.email, 'johndoe@example.com');
        expect(user.name, 'John');
        expect(user.surname, 'Doe');

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockEmail'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);
        const String mockEmail = 'johndoe@example.com';

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockEmail'))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await userService.getUserByEmail(mockEmail), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockEmail'))).called(1);
      });
    });

    group('createUser', () {
      test('create a user', () async {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);

        when(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(mockUserObject.toJson()),
        )).thenAnswer((_) async => http.Response(json.encode(mockUserResponse), 201));

        final user = await userService.createUser(mockUserObject);

        expect(user, isA<User>());
        expect(user.id, equals(1));
        expect(user.email, 'johndoe@example.com');
        expect(user.name, 'John');
        expect(user.surname, 'Doe');

        verify(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(mockUserObject.toJson()),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);

        when(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(mockUserObject.toJson()),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await userService.createUser(mockUserObject), throwsException);

        verify(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(mockUserObject.toJson()),
        )).called(1);
      });
    });

    group('updateUserByEmail', () {
      test('returns an updated user', () async {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);
        const String mockEmail = 'johndoe@example.com';

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(mockClient.put(
          Uri.parse('$API_BASE_URL/$mockEmail'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(mockUserObject.toJson()),
        )).thenAnswer((_) async => http.Response(json.encode(mockUserResponse), 200));

        final user = await userService.updateUserByEmail(mockEmail, mockUserObject);

        expect(user, isA<User>());
        expect(user.id, equals(1));
        expect(user.email, 'johndoe@example.com');
        expect(user.name, 'John');
        expect(user.surname, 'Doe');

        verify(mockClient.put(
          Uri.parse('$API_BASE_URL/$mockEmail'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(mockUserObject.toJson()),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);
        const String mockEmail = 'johndoe@example.com';

        // Use Mockito to return an unsuccessful response when it calls the
        // provided http.Client.
        when(mockClient.put(
          Uri.parse('$API_BASE_URL/$mockEmail'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(mockUserObject.toJson()),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await userService.updateUserByEmail(mockEmail, mockUserObject), throwsException);

        verify(mockClient.put(
          Uri.parse('$API_BASE_URL/$mockEmail'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(mockUserObject.toJson()),
        )).called(1);
      });
    });

    group('deleteUserByEmail', () {
      test('is called once', () async {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);
        const String mockEmail = 'johndoe@example.com';

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockEmail'),
        )).thenAnswer((_) async => http.Response('[]', 204));

        await userService.deleteUserByEmail(mockEmail);

        verify(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockEmail'),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);
        const String mockEmail = 'johndoe@example.com';

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockEmail'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await userService.deleteUserByEmail(mockEmail), throwsException);

        verify(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockEmail'),
        )).called(1);
      });
    });

    group('deleteUsers', () {
      test('is called once', () async {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);

        when(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).thenAnswer((_) async => http.Response('[]', 204));

        await userService.deleteUsers();

        verify(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        userService = UserService(client: mockClient);

        when(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await userService.deleteUsers(), throwsException);

        verify(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).called(1);
      });
    });
  });
}
