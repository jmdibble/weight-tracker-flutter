import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weighttrackertwo/bloc/auth/auth_bloc.dart';
import 'package:weighttrackertwo/bloc/auth/auth_event.dart';
import 'package:weighttrackertwo/bloc/auth/auth_state.dart';
import 'package:weighttrackertwo/models/user_model.dart';
import 'package:weighttrackertwo/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('Get Current User', () {
    final user = User();

    test("User signs in and Bloc produces a User object", () {
      when(mockAuthService.signIn(any, any)).thenAnswer((_) async => user);

      final bloc = AuthBloc(authService: mockAuthService);

      bloc.add(SigninEvent(email: "josh@josh2.com", password: "12345678"));

      expectLater(
        bloc,
        emitsInOrder([
          AuthInitialState(),
          AuthLoadingState(),
          AuthorisedState(),
        ]),
      );
    });
  });
}
