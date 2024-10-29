import 'package:animated_login/animated_login.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/router/page_router.dart';
import 'package:raptorx/src/core/router/route_name.dart';
import 'package:raptorx/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:raptorx/src/features/auth/domain/usecases/signup_usecase.dart';
import 'package:raptorx/src/features/auth/presentation/view_model/auth_generic.dart';

final authProvider = StateNotifierProvider<AuthController, AuthGeneric>((ref) => AuthController(ref: ref));
class AuthController extends StateNotifier<AuthGeneric>{
  AuthController({required this.ref}):super(AuthGeneric());

  Ref ref;

  SignupUseCase signupUseCase = SignupUseCase();
  LoginUseCase loginUseCase = LoginUseCase();



  Future<String?> loginUser(LoginData data) async{
    state = state.update(loading: true);

    final showBot = BotToast.showLoading();

    UserCredential? userCredential = await loginUseCase.call(data: data);


    state = state.update(loading: false, userCredential: userCredential, loginData: data, currentMode: userCredential!=null?AuthMode.login.name:null);
    showBot();

    if(userCredential!=null){
      final showSuccessSignup = BotToast.showText(text: "Login successful");
      ref.read(goRouterProvider).go(RouteName.homeRoute);
    }

    return userCredential?.user?.email;

  }

  Future<String?> signupUser(SignUpData data) async{

    state = state.update(loading: true);

    final showBot = BotToast.showLoading();

    UserCredential? userCredential = await signupUseCase.call(data: data);


    state = state.update(loading: false, userCredential: userCredential, signupData: data, currentMode: userCredential!=null?AuthMode.login.name:null);
    showBot();

    if(userCredential!=null){
      final showSuccessSignup = BotToast.showText(text: "Signup successful, please login");
      ref.read(goRouterProvider).go(RouteName.homeRoute);
    }


    return userCredential?.user?.email;

  }

  Future<String> recoverPassword(String name) async{
    return "";
  }

  User? authState(){
    return FirebaseAuth.instance.currentUser;
  }


  void updateAuthMode(AuthMode authMode){
    print(authMode.name);
    state = state.update(currentMode: authMode.name);
  }

}