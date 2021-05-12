import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectnew/features/presentation/providers/authNotifier.dart';

import 'package:projectnew/utils/State_management/state.dart';

import 'package:projectnew/utils/reusableWidgets/CustomTextField.dart';

import 'package:provider/provider.dart';

import 'GetStartedScreen.dart';
import 'SignUpView.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController;
  TextEditingController passwordController;

  var _logInFormkey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('login');
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Form(
          key: _logInFormkey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              SizedBox(
                height: 300,
              ),
              _title(),
              SizedBox(
                height: 50,
              ),
              Column(
                children: <Widget>[
                  TextFormFieldOther(
                      controller: emailController, hinttext: "Email id"),
                  TextFormFieldPassword(
                    controller: passwordController,
                    hinttext: 'Password',
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<AuthNotifier>(
                builder: (context, state, __) {
                  switch (state.loginUseCase.state) {
                    case ResponseState.LOADING:
                      return Center(
                        child: SpinKitThreeBounce(
                          color: Colors.deepOrange,
                        ),
                      );
                      break;
                    case ResponseState.ERROR:
                      return Center(
                        child: Column(
                          children: [
                            Text(state.loginUseCase.exception),
                            TextButton(
                              child: Text('try again'),
                              onPressed: () {
                                state.resetState();
                              },
                            )
                          ],
                        ),
                      );
                      break;
                    case ResponseState.COMPLETE:

                      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      //   state.resetState();

                      //   Navigator.pushNamed(context, HomeView.routeName);
                      // });

                      break;
                  }
                  return _submitButton();
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerRight,
                child: Text('Forgot Password ?',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _createAccountLabel(),
              ),
            ],
          ),
        ),

        Positioned(top: 40, left: 0, child: _backButton()),
        // Positioned(top: 0, right: 0, child: BezierContainer())
      ],
    ));
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return RoundedFlatBtn(
      color: Colors.deepOrange,
      onPressed: () async {
        print('hello');
        if (_logInFormkey.currentState.validate()) {
          context
              .read<AuthNotifier>()
              .login(emailController.text, passwordController.text)
              .then((value) {
            if (value) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: Text('Hello ,you are signedin successfully.'),
                    ),
                  );
                },
              ));
            }
          });
          //     .then((value) {
          //   context
          //       .read<ProfileViewModel>()
          //       .getUserProfileData(value)
          //       .then((value) {
          //     profileViewModel.saveUserData(value);
          //   });
          //   Navigator.pushReplacementNamed(context, HomeView.routeName);
          //
          // }
          // );

        }
      },
      text: "Login",
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Let',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
          children: [
            TextSpan(
              text: 'S',
              style: TextStyle(color: Colors.blueAccent, fontSize: 30),
            ),
            TextSpan(
              text: 'talk',
              style: TextStyle(color: Colors.red, fontSize: 30),
            ),
          ]),
    );
  }
}
