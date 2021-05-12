import 'dart:math';

import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/domain/repositories/Auth/AuthRepo.dart';

class SignupMethod {
  final AuthRepo authRepo;
  SignupMethod(this.authRepo);
  Future<ErrorHandle> call(email, password) async {
    return authRepo.signUp(email, password);
  }
}
