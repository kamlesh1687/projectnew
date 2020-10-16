import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projectnew/ui/Authentication/SignUp/SignUp_view.dart';

import 'package:projectnew/ui/Views/Home_screen/Landing_page/home_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
          return SignUpView();
        });
  }
}
