import 'package:flutter/cupertino.dart';
import 'package:projectnew/core/failures/errorHandling.dart';
import 'package:projectnew/features/domain/usecases/auth/LoginCase.dart';
import 'package:projectnew/features/domain/usecases/auth/LogoutCase.dart';
import 'package:projectnew/features/domain/usecases/auth/SignupCase.dart';
import 'package:projectnew/utils/State_management/state_manage.dart';

class AuthNotifier extends ChangeNotifier {
  final LoginMethod _loginMethod;
  final LogoutMethod _logoutMethod;
  final SignupMethod _signupMethod;
  AuthNotifier(
      {@required LoginMethod login,
      @required LogoutMethod logout,
      @required SignupMethod signup})
      : assert(login != null),
        assert(logout != null),
        assert(signup != null),
        _loginMethod = login,
        _logoutMethod = logout,
        _signupMethod = signup;
  Response<bool> loginUseCase = Response<bool>();

  void _setLoginUseCase(Response response) {
    loginUseCase = response;
    notifyListeners();
  }

  logout() {
    _logoutMethod.call();
    resetState();
  }

  resetState() {
    var respose = Response<bool>();
    _setLoginUseCase(respose);
    _setSignUp(respose);
  }

  Future login(String email, String password) async {
    _setLoginUseCase(Response.loading<bool>());
    _loginMethod.call(email, password).then((value) {
      if (value.errorState == ErrorState.OnError) {
        _setLoginUseCase(Response.error<bool>(value.error));
      } else
        _setLoginUseCase(Response.complete<bool>(true));
    });
  }

/* --------------------------------- SignUp --------------------------------- */
  Response<bool> signUpUseCase = Response<bool>();

  void _setSignUp(Response response) {
    signUpUseCase = response;
    notifyListeners();
  }

  Future signUp(String email, String password) async {
    _setSignUp(Response.loading<bool>());
    _signupMethod.call(email, password).then((value) {
      switch (value.errorState) {
        case ErrorState.OnError:
          _setSignUp(Response.error<bool>(value.error));
          break;
        case ErrorState.NoError:
          _setSignUp(Response.complete<bool>(true));
          break;
      }
    });
  }
}
