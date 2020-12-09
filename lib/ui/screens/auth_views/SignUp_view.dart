import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:projectnew/business_logics/view_models/Auth_viewmodel.dart';
import 'package:projectnew/utils/Widgets.dart';

import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController _emailController;

  TextEditingController _nameController;

  TextEditingController _passwordController;

  TextEditingController _passwordConfirmController;

  void initState() {
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();

    super.initState();
  }

  username() {
    return SignUpTextField(
      controller: _nameController,
      hintText: "Enter name",
    );
  }

  confirmPassword() {
    return SignUpTextField(
      controller: _passwordConfirmController,
      hintText: "Enter password again",
    );
  }

  @override
  Widget build(BuildContext context) {
    print("SignUpview");
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Colors.blueGrey),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Center(
              child: Container(
                child: Text(
                  "Welcome",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Consumer<AuthViewModel>(builder: (_, _values, __) {
              return CardContainer(
                  values: CrdConValue(
                color: Colors.white12,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _values.isSignupScreen ? 'Signup' : 'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            switchInCurve: Curves.bounceIn,
                            switchOutCurve: Curves.bounceOut,
                            duration: Duration(seconds: 1),
                            child: _values.child1 ?? username(),
                          ),
                          AnimatedContainer(
                            duration: Duration(seconds: 1),
                            child: SignUpTextField(
                              controller: _emailController,
                              hintText: "Enter email",
                            ),
                          ),
                          SignUpTextField(
                            controller: _passwordController,
                            hintText: "Enter password ",
                          ),
                          AnimatedSwitcher(
                            switchInCurve: Curves.bounceIn,
                            switchOutCurve: Curves.bounceInOut,
                            duration: Duration(seconds: 1),
                            child: _values.child2 ?? confirmPassword(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                !_values.isSignupScreen
                                    ? Container()
                                    : Expanded(
                                        child: RaisedButton(
                                          color: Colors.blueGrey,
                                          textColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Text("Signup"),
                                          onPressed: () {
                                            if (_emailController.text.isEmpty &&
                                                _passwordController
                                                    .text.isEmpty &&
                                                _passwordConfirmController
                                                    .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Please enter your details'),
                                              ));
                                            }
                                            if (_passwordController
                                                    .text.length >
                                                5) {
                                              if (_passwordController.text ==
                                                  _passwordConfirmController
                                                      .text) {
                                                context
                                                    .read<AuthViewModel>()
                                                    .signUpFunc(
                                                        _nameController.text,
                                                        _emailController.text,
                                                        _passwordController
                                                            .text);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Password is not same'),
                                                ));
                                              }
                                            }

                                            if (_passwordController
                                                        .text.length <
                                                    5 &&
                                                _emailController
                                                    .text.isNotEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Password is too short'),
                                              ));
                                            }
                                          },
                                        ),
                                      ),
                                _values.isSignupScreen
                                    ? Container()
                                    : Expanded(
                                        child: RaisedButton(
                                          color: Colors.blueGrey,
                                          textColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Text("Login"),
                                          onPressed: () {
                                            context
                                                .read<AuthViewModel>()
                                                .loginmethod(
                                                    _emailController.text,
                                                    _passwordController.text);
                                          },
                                        ),
                                      )
                              ],
                            ),
                          ),
                          _values.isSignupScreen
                              ? RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      text: "Already have a account,",
                                      children: [
                                        TextSpan(
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold),
                                            text: 'Click here.',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                _values.child1 = Container();
                                                _values.child2 = Container();

                                                _values.isSignupScreen = false;
                                              }),
                                      ]),
                                )
                              : Container(),
                          !_values.isSignupScreen
                              ? RichText(
                                  text: TextSpan(
                                      text: "Create new account,",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      children: [
                                      TextSpan(
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold),
                                          text: 'Click here.',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              _values.child1 = username();
                                              _values.child2 =
                                                  confirmPassword();

                                              _values.isSignupScreen = true;
                                            })
                                    ]))
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ));
            })
          ],
        ),
      ),
    ));
  }
}

class SignUpTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final transValue;

  const SignUpTextField(
      {Key key, this.controller, this.hintText, this.transValue})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
