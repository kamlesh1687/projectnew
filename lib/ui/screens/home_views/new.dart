import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/models/userModel.dart';
import 'package:projectnew/business_logics/view_models/Splash_screenmodel.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  // ignore: unused_field
  final String userId;

  const UserProfile(this.userId);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    UseR userdata = context.watch<SplashScreenModel>().profileUserModel;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FlatButton(
              onPressed: () {
                context
                    .read<SplashScreenModel>()
                    .getProfileData(userid: widget.userId);
              },
              child: Text("GetData"),
            ),
            ListTile(
              title: Text(userdata?.displayName ?? ""),
            )
          ],
        ),
      ),
    );
  }
}
