import 'package:raptorx/src/features/auth/data/model/LoginRequest.dart';
import 'package:raptorx/src/features/auth/data/model/SignupRequest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<User?> signup({required SignupRequest signupData});
  Future<User?> login({required LoginRequest loginData});
}
