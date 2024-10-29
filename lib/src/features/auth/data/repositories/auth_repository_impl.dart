import 'package:animated_login/animated_login.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raptorx/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository{
  @override
  Future<UserCredential?> signup({required SignUpData signupData}) async{

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: signupData.email,
          password: signupData.password
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        BotToast.showText(text: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        BotToast.showText(text: 'The account already exists for that email.');
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
    return null;
  }

  @override
  Future<UserCredential?> login({required LoginData loginData}) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginData.email,
          password: loginData.password
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        BotToast.showText(text: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        BotToast.showText(text: 'Wrong password provided for that user.');
      }
    }
    return null;
  }

}