import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final String fullName;
  final String email;
  final String studentId;
  final String password;

  const RegisterRequested({
    required this.fullName,
    required this.email,
    required this.studentId,
    required this.password,
  });

  @override
  List<Object> get props => [fullName, email, studentId, password];
}
