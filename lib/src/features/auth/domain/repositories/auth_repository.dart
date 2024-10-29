import 'package:animated_login/animated_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository{

  Future<UserCredential?> signup({required SignUpData signupData});

  Future<UserCredential?> login({required LoginData loginData});

}