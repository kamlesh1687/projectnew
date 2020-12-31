import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/ui/screens/auth_views/SignUp_view.dart';
import 'package:projectnew/ui/screens/home_views/home_view.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting");
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue[50],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print("done");
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue[50],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.none) {
            print("Waiting");
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue[50],
              ),
            );
          }

          print("connected");
          if (snapshot.data != null) {
            print('building HomeView From Splash Screen');

            return HomeView(fireBaseUserID: snapshot.data.uid);
          }
          // Provider.of<ProfileViewModel>(context).logoutCallBack();
          return SignUpView();
        });
  }
}
