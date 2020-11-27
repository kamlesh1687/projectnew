import 'package:flutter/material.dart';
import 'package:projectnew/business_logics/models/userModel.dart';

class ChatView extends StatelessWidget {
  final UseR userData;

  final String currenUserId;

  ChatView({@required this.userData, @required this.currenUserId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userData.displayName),
      ),
      body: Center(
        child: Text("$currenUserId " + "${userData.userId}"),
      ),
    );
  }
}
