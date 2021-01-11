import 'package:flutter/cupertino.dart';
import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/data/datasources/remote/authService.dart';
import 'package:projectnew/features/domain/repositories/Auth/AuthRepo.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthService authService;

  AuthRepoImpl({@required this.authService});
  @override
  Future<ErrorHandle> signIn(String email, String password) {
    return authService.signIn(email, password);
  }

  @override
  signOut() {
    authService.signOut();
  }

  @override
  Future<ErrorHandle> signUp(String email, String password) async {
    return authService.signUp(email, password);
  }
}
