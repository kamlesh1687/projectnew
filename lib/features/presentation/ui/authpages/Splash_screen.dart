import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projectnew/features/presentation/ui/authpages/GetStartedScreen.dart';

import 'package:projectnew/ui/screens/home_views/home_view.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/authView';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            print("connected");

            return HomeView();
          }
          if (snapshot.connectionState != ConnectionState.active) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue[50],
              ),
            );
          }
          return GetStarted();
        });
  }
}
