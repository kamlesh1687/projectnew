import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/domain/repositories/Auth/AuthRepo.dart';

class LoginMethod {
  final AuthRepo authRepo;
  LoginMethod(this.authRepo);
  Future<ErrorHandle> executeLogIn(email, password) async {
    return authRepo.signIn(email, password);
  }
}
