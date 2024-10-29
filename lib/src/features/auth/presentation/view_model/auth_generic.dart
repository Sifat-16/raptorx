import 'package:animated_login/animated_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGeneric{
  LoginData? loginData;
  SignUpData? signupData;
  bool loading;
  UserCredential? userCredential;
  String currentMode;


  AuthGeneric({
    this.loginData,
    this.loading = false,
    this.userCredential,
    this.signupData,
    this.currentMode = "login"
});

  AuthGeneric update({
    LoginData? loginData,
    bool? loading,
    UserCredential? userCredential,
    SignUpData? signupData,
    String? currentMode
}){
    return AuthGeneric(
      loginData: loginData??this.loginData,
      loading: loading??this.loading,
      userCredential: userCredential??this.userCredential,
      signupData: signupData??this.signupData,
      currentMode: currentMode??this.currentMode
    );
  }


}