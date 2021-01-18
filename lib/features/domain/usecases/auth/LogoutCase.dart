import 'package:projectnew/features/domain/repositories/Auth/AuthRepo.dart';

class LogoutMethod {
  final AuthRepo authRepo;
  LogoutMethod(this.authRepo);
  Future<String> call() async {
    return authRepo.signOut();
  }
}
