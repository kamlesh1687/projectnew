import 'dart:math';

import 'package:projectnew/core/failures/errorHandling.dart';

abstract class AuthRepo {
  Future<ErrorHandle> signUp(String email, String password);
  Future<ErrorHandle> signIn(String email, String password);
  signOut();
}
