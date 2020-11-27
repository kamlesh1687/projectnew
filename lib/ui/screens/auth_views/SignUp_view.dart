import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:projectnew/business_logics/view_models/Auth_viewmodel.dart';

import 'package:projectnew/utils/Widgets.dart';

import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("SignUpview");
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.teal.shade300])),
        child: SingleChildScrollView(
          child: Form(key: _formKey, child: SignUpSwitch()),
        ),
      ),
    );
  }
}

class SignUpSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("SignUpviewSwitch");

    return Consumer<AuthViewModel>(builder: (context, value, __) {
      var color1 = value.isSignupScreen ? Colors.blue[400] : Colors.blue[100];
      var color2 = !value.isSignupScreen ? Colors.blue[400] : Colors.blue[100];
      return Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      value.isSignupScreen
                          ? "Create Your Account"
                          : "Already Have Account ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            value.isSignupScreen
                ? Inputtextfield(
                    hinttext: "Enter your Name",
                    controllerText: value.usernameController,
                  )
                : Container(),
            Inputtextfield(
              hinttext: "Enter your Email",
              controllerText: value.emailController,
            ),
            Inputtextfield(
              hinttext: "Enter your Password",
              controllerText: value.passwordController,
            ),
            SizedBox(
              height: 30,
            ),
            // value.signUpState == SignUpState.Loading
            //     ? Center(
            //         child: LinearProgressIndicator(),
            //       )
            //     :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Buttons(
                    color: color1,
                    functon: () {
                      value.btn2Func(
                          value.emailController.text,
                          value.passwordController.text,
                          value.usernameController.text);
                    },
                    text: "SignUp"),
                Buttons(
                    color: color2,
                    functon: () {
                      value.btn1Func(
                        value.emailController.text,
                        value.passwordController.text,
                      );
                    },
                    text: "LogIn"),
              ],
            ),
          ],
        ),
      );
    });
  }
}
