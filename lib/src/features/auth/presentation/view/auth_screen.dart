import 'package:animated_login/animated_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/auth/presentation/view_model/auth_controller.dart';

class AuthScreen extends ConsumerWidget {
  AuthScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final auth = ref.watch(authProvider);
    return  CupertinoPageScaffold(
      child: AnimatedLogin(
        onLogin: ref.read(authProvider.notifier).loginUser,
        onSignup: ref.read(authProvider.notifier).signupUser,
        onForgotPassword: ref.read(authProvider.notifier).recoverPassword,
        passwordValidator: ValidatorModel(

        ),
        //logo: Image.asset('assets/images/raptor.png'),
        backgroundImage: 'assets/images/raptor.png',
        signUpMode: SignUpModes.both,
        loginDesktopTheme: _desktopTheme,
        loginMobileTheme: _mobileTheme,
        loginTexts: _loginTexts,
        initialMode: auth.currentMode=="login"?AuthMode.login:AuthMode.signup,
        onAuthModeChange: ref.read(authProvider.notifier).updateAuthMode,

      ),
    );
  }

  LoginViewTheme get _mobileTheme => LoginViewTheme(
    // showLabelTexts: false,
    backgroundColor: Colors.black, // const Color(0xFF6666FF),
    formFieldBackgroundColor: Colors.white,
    formWidthRatio: 60,
    fillColor: Colors.black
    // actionButtonStyle: ButtonStyle(
    //   foregroundColor: MaterialStateProperty.all(Colors.blue),
    // ),
  );

  LoginViewTheme get _desktopTheme => _mobileTheme.copyWith(
    // To set the color of button text, use foreground color.
    actionButtonStyle: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),

    backgroundColor: Colors.black,

    dialogTheme: const AnimatedDialogTheme(

      languageDialogTheme: LanguageDialogTheme(
          optionMargin: EdgeInsets.symmetric(horizontal: 80)),
    ),
  );

  LoginTexts get _loginTexts => LoginTexts(
    nameHint: _username,
    login: _login,
    signUp: _signup,
    welcomeBack: _welcomeBack,
    welcomeBackDescription: _welcomeBackDescription,
    welcome: _welcomeBack,
    welcomeDescription: _welcomeBackDescription
  );

  /// You can adjust the texts in the screen according to the current language
  /// With the help of [LoginTexts], you can create a multilanguage scren.
  String get _username => 'Username';
  String get _login => 'Login';
  String get _signup => 'Sign Up';
   String get _welcomeBack => 'Raptor-X';

   String get _welcomeBackDescription => 'Welcome back to Automation Engine';
}
