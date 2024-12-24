import 'package:raptorx/src/config/server/hades.dart';
import 'package:raptorx/src/features/auth/data/model/LoginRequest.dart';
import 'package:raptorx/src/features/auth/data/model/SignupRequest.dart';
import 'package:raptorx/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<User?> signup({required SignupRequest signupData}) async {
    try {
      final AuthResponse res = await Hades.supabase.auth.signUp(
        email: signupData.email,
        password: signupData.password,
      );
      return res.user;
    } catch (e) {
      print("Error in signup ${e}");
    }
    return null;
  }

  @override
  Future<User?> login({required LoginRequest loginData}) async {
    try {
      final AuthResponse res = await Hades.supabase.auth.signInWithPassword(
        email: loginData.email,
        password: loginData.password,
      );
      return res.user;
    } catch (e) {
      print("Error in login ${e}");
    }
    return null;
  }
}
