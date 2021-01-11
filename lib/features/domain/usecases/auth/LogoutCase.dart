import 'package:projectnew/features/domain/repositories/Auth/AuthRepo.dart';

class LogoutMethod {
  final AuthRepo authRepo;
  LogoutMethod(this.authRepo);
  Future<String> executeLogout() async {
    return authRepo.signOut();
  }
}
