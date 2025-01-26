import 'package:chatrify/features/auth/domain/use_cases/login_use_case.dart';
import 'package:chatrify/features/auth/domain/use_cases/register_use_case.dart';
import 'package:chatrify/features/auth/presentation/bloc/auth_event.dart';
import 'package:chatrify/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final _storage = FlutterSecureStorage();

  AuthBloc({required this.registerUseCase, required this.loginUseCase})
      : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user =
          await registerUseCase(event.username, event.email, event.password);

      emit(AuthSuccess(message: "Успешна регистрација"));
    } catch (e) {
      emit(AuthFailure(error: "Неуспешна регистрација"));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.email, event.password);

      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'userId', value: user.id);
      print('token: ${user.token}');

      emit(AuthSuccess(message: "Успешно логирање"));
    } catch (e) {
      emit(AuthFailure(error: "Неуспешно логирање"));
    }
  }
}
