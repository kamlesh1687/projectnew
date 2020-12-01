import 'package:firebase_auth/firebase_auth.dart';

import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:projectnew/services/firebaseServices.dart';

import '../appstate.dart';

enum SignUpState { Loading, Loaded }
FirebaseServices firebaseServices = FirebaseServices();

class AuthViewModel extends AppState {
/* ------------------------------ Loadingstatus ----------------------------- */

  SignUpState _signUpState = SignUpState.Loaded;
  get signUpState => _signUpState;
  set signUpState(_value) {
    _signUpState = _value;
  }

/* ------------------ Declaration of objects and variables ------------------ */

  bool _isSignupScreen = true;

/* ------------------------------- All Getters ------------------------------ */

  get isSignupScreen => _isSignupScreen;

/* ------------------------------- All Setters ------------------------------ */

  set isSignupScreen(value) {
    _isSignupScreen = value;
    notifyListeners();
  }

/* --------------------- Switch between login and signUp -------------------- */
  void btn2Func(_email, _password, _userName) {
    if (isSignupScreen) {
      signUpFunc(_email, _password, _userName);
    }
    isSignupScreen = true;
  }

  void btn1Func(_email, _pass) {
    if (!isSignupScreen) {
      loginmethod(_email, _pass);
    }
    isSignupScreen = false;
  }

/* --------------------- CreateUserwithEmailAndPassword --------------------- */
  Future signUpFunc(String _email, String _password, String _userName) async {
    print("started");
    try {
      firebaseServices.signUp(_email, _password).then((value) {
        String _userId = FirebaseAuth.instance.currentUser.uid;

        firebaseServices
            .createUser(defaultUser(
                email: _email, userId: _userId, userName: _userName))
            .then((value) {
          print('done');
        });
      });
    } catch (e) {}
  }

/* ----------------------- SignInWithEmailAndPassword ----------------------- */

  void loginmethod(_email, _pass) {
    try {
      firebaseServices.signIn(_email, _pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'Given String is empty or null') {
        print('Wrong password provided for that user.');
      }
    }
  }

/* ------------------------------ End of class ------------------------------ */

}
