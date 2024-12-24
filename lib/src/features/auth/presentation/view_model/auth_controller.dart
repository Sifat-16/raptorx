import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/config/server/hades.dart';
import 'package:raptorx/src/core/router/page_router.dart';
import 'package:raptorx/src/core/router/route_name.dart';
import 'package:raptorx/src/features/auth/data/model/LoginRequest.dart';
import 'package:raptorx/src/features/auth/data/model/SignupRequest.dart';
import 'package:raptorx/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:raptorx/src/features/auth/domain/usecases/signup_usecase.dart';
import 'package:raptorx/src/features/auth/presentation/view_model/auth_generic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = StateNotifierProvider<AuthController, AuthGeneric>(
    (ref) => AuthController(ref: ref));

class AuthController extends StateNotifier<AuthGeneric> {
  AuthController({required this.ref}) : super(AuthGeneric());

  Ref ref;

  SignupUseCase signupUseCase = SignupUseCase();
  LoginUseCase loginUseCase = LoginUseCase();

  Future<String?> loginUser(LoginRequest data) async {
    state = state.update(loading: true);

    User? user = await loginUseCase.call(data: data);

    state = state.update(
      loading: false,
      user: user,
      loginData: data,
    );

    print("Loading value ${state.loading}");

    if (user != null) {
      final showSuccessSignup = BotToast.showText(text: "Login successful");
      ref.read(goRouterProvider).go(RouteName.homeRoute);
    }

    return user?.email;
  }

  Future<String?> signupUser(SignupRequest data) async {
    state = state.update(loading: true);

    final showBot = BotToast.showLoading();

    User? user = await signupUseCase.call(data: data);

    state = state.update(loading: false, user: user, signupData: data);
    showBot();

    if (user != null) {
      final showSuccessSignup =
          BotToast.showText(text: "Signup successful, please login");
      ref.read(goRouterProvider).go(RouteName.homeRoute);
    }

    return user?.email;
  }

  Future<String> recoverPassword(String name) async {
    return "";
  }

  User? authState() {
    return Hades.supabase.auth.currentUser;
  }
}
