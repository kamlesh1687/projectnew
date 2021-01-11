import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectnew/core/failures/errorHandling.dart';

class AuthService {
  AuthService();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<ErrorHandle> signUp(String _email, String _pass) async {
    try {
      return await _auth
          .createUserWithEmailAndPassword(email: _email, password: _pass)
          .then((value) {
        return ErrorHandle.noError<UserCredential>(value);
      });
    } catch (e) {
      return ErrorHandle.onError<String>(e.toString());
    }
  }

  Future<ErrorHandle> signIn(String _email, String _pass) async {
    try {
      return await _auth
          .signInWithEmailAndPassword(email: _email, password: _pass)
          .then((value) {
        return ErrorHandle.noError<UserCredential>(value);
      });
    } catch (e) {
      return ErrorHandle.onError<String>(e.toString());
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
