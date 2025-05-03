import 'package:safe_campus/features/core/data/data_sources/auth_service.dart';
import 'package:safe_campus/features/core/data/models/register_data.dart';
import 'package:safe_campus/features/core/data/models/user_model.dart';

class AuthRepo {
  final AuthService _authService = AuthService();
  //register
  Future<UserModel> registerUser(RegisterData data) async {
    return await _authService.register(data);
  }

  //loginn
  Future<UserModel> loginUser(String email, String password) async {
    return await _authService.login(email, password);
  }
}
