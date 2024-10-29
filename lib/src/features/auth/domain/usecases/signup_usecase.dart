import 'package:animated_login/animated_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raptorx/src/core/dependency_injection/dependency_injection.dart';
import 'package:raptorx/src/core/domain/usecases.dart';
import 'package:raptorx/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:raptorx/src/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase extends UseCase<UserCredential?, SignUpData>{

  AuthRepository authRepository = sl.get<AuthRepositoryImpl>();

  @override
  Future<UserCredential?> call({
    required SignUpData data
}) async{
    return await authRepository.signup(signupData: data);
  }

}