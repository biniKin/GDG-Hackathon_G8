import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String studentId;
  final String password;

  const SignInRequested(this.studentId, this.password);
}

class RegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String studentId;
  final String password;

  const RegisterRequested(this.fullName, this.email, this.studentId, this.password);
}
