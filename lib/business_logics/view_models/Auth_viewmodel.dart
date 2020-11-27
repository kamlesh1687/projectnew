import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
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
            .createUser(user(_userId, _email, _userName))
            .then((value) {
          emailController.clear();
          passwordController.clear();
          usernameController.clear();
          print('done');
        });
      });
    } catch (e) {}
  }

  UseR user(String _userId, String _email, String _userName) {
    return UseR(
      userId: _userId,
      displayName: _userName,
      userEmail: _email,
      userDescription: "Enter Your Description",
      photoUrl:
          "https://tribunest.com/wp-content/uploads/2019/02/dummy-profile-image.png",
    );
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
