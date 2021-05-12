import 'dart:math';

import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/domain/repositories/Auth/AuthRepo.dart';

class DummyAuth extends AuthRepo {
  @override
  Future<ErrorHandle> signIn(String email, String password) {
    return Future.delayed(Duration(seconds: 5)).then((value) {
      final _random = Random();

      final randomBool = _random.nextBool();
      print(randomBool);
      if (randomBool) {
        return ErrorHandle.noError<bool>(true);
      } else {
        return ErrorHandle.onError<String>('Sorry,your email have some issues');
      }
    });
  }

  @override
  signOut() {}

  @override
  Future<ErrorHandle> signUp(String email, String password) {
    return Future.delayed(Duration(seconds: 5)).then((value) {
      final _random = Random();

      final randomBool = _random.nextBool();
      print(randomBool);
      if (randomBool) {
        return ErrorHandle.noError<bool>(true);
      } else {
        return ErrorHandle.onError<String>('Sorry,your email have some issues');
      }
    });
  }
}
