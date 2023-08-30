import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validator/domain/entities/token.dart';
import 'package:validator/domain/services/auth_service_interface.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/presentation/pages/pages.dart';
import 'login_screen_unit_test.mocks.dart';

@GenerateMocks([IAuthService, IEventService, SharedPreferences])
void main() {
  group('LoginScreen Widget Tests', () {
    late MockIAuthService mockAuthService;
    late MockIEventService mockEventService;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      // Set up mock services
      mockAuthService = MockIAuthService();
      mockEventService = MockIEventService();
      mockSharedPreferences = MockSharedPreferences();

      // Define the behaviour on the calls
      when(mockAuthService.login(any)).thenAnswer((_) async => const Token(accessToken: 'mockedTokenValue'));
      when(mockEventService.getEvents()).thenAnswer((_) async => []);
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      // Replace the actual services with the mocks
      GetIt.I.registerSingleton<IAuthService>(mockAuthService);
      GetIt.I.registerSingleton<IEventService>(mockEventService);
      GetIt.I.registerSingleton<SharedPreferences>(mockSharedPreferences);
    });

    tearDown(() {
      // Unregister the dependencies on finishing the tests
      GetIt.I.unregister<IAuthService>();
      GetIt.I.unregister<IEventService>();
      GetIt.I.unregister<SharedPreferences>();
    });

    testWidgets('LoginScreen displays Log in button when not loading', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      final logInButtonFinder = find.text('Log in');
      expect(logInButtonFinder, findsOneWidget);
      final circularProgressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(circularProgressIndicatorFinder, findsNothing);
    });

    testWidgets('Tapping Log in button triggers the login process and navigation', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final logInButtonFinder = find.text('Log in');
      expect(logInButtonFinder, findsOneWidget);

      await tester.tap(logInButtonFinder);
      await tester.pumpAndSettle();

      verify(mockAuthService.login(any)).called(1);
      verify(mockSharedPreferences.setString(any, any)).called(1);

      expect(logInButtonFinder, findsNothing);

      expect(find.byType(MainScreen), findsOneWidget);
    });
  });
}
