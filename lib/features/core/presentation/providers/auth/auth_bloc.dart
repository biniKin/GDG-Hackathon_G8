import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/core/data/models/register_data.dart';
import 'package:safe_campus/features/core/data/repositories/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc({required this.authRepo}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.loginUser(event.studentId, event.password);
      emit(Authenticated(user)); // pass the user to the state
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final data = RegisterData(
        fullname: event.fullName,
        email: event.email,
        studentId: event.studentId,
        password: event.password,
      );
      final user = await authRepo.registerUser(data);
      emit(Authenticated(user)); // pass the user to the state
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
