import 'package:raptorx/src/features/auth/data/model/LoginRequest.dart';
import 'package:raptorx/src/features/auth/data/model/SignupRequest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGeneric {
  LoginRequest? loginData;
  SignupRequest? signupData;
  bool loading;
  User? user;

  AuthGeneric(
      {this.loginData, this.loading = false, this.user, this.signupData});

  AuthGeneric update(
      {LoginRequest? loginData,
      bool? loading,
      User? user,
      SignupRequest? signupData}) {
    return AuthGeneric(
        loginData: loginData ?? this.loginData,
        loading: loading ?? this.loading,
        user: user ?? this.user,
        signupData: signupData ?? this.signupData);
  }
}
