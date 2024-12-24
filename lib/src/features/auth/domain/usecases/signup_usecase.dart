import 'package:raptorx/src/core/dependency_injection/dependency_injection.dart';
import 'package:raptorx/src/core/domain/usecases.dart';
import 'package:raptorx/src/features/auth/data/model/SignupRequest.dart';
import 'package:raptorx/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:raptorx/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupUseCase extends UseCase<User?, SignupRequest> {
  AuthRepository authRepository = sl.get<AuthRepositoryImpl>();

  @override
  Future<User?> call({required SignupRequest data}) async {
    return await authRepository.signup(signupData: data);
  }
}
