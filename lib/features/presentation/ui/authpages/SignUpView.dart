import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectnew/features/presentation/providers/authNotifier.dart';
import 'package:projectnew/features/presentation/providers/Profile_viewmodel.dart';
import 'package:projectnew/utils/State_management/state.dart';

import 'package:projectnew/utils/reusableWidgets/CustomTextField.dart';

import 'package:provider/provider.dart';

import 'CreateUser.dart';
import 'GetStartedScreen.dart';
import 'LogInView.dart';

ProfileViewModel profile = ProfileViewModel();

class SignUpPage extends StatefulWidget {
  static const routeName = '/SignUpPage';
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPassController;
  var _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPassController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('building');

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Form(
          key: _formkey,
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
                  TextFormFieldPassword(
                    controller: confirmPassController,
                    hinttext: 'Confirm Password',
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<AuthNotifier>(
                builder: (context, state, __) {
                  switch (state.signUpUseCase.state) {
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
                            Text(state.signUpUseCase.exception),
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
                      if (state.signUpUseCase.data) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          print('helllo');
                          state.resetState();
                          Navigator.pushNamed(context, CreateNewUser.routeName);
                        });

                        return Text(state.signUpUseCase.data.toString());
                      }

                      break;
                  }
                  return RoundedFlatBtn(
                    color: Colors.deepOrange,
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        print('tapped');
                        if (passwordController.text ==
                            confirmPassController.text) {
                          context
                              .read<AuthNotifier>()
                              .signUp(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            print(value.toString());
                          });
                        }
                      }
                    },
                    text: "SignUp",
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already have an account ?',
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
                          Navigator.pushNamed(context, LoginPage.routeName);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: 40,
            left: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      child:
                          Icon(Icons.keyboard_arrow_left, color: Colors.black),
                    ),
                    Text('Back',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            )),
        // Positioned(
        //     top: -MediaQuery.of(context).size.height * .15,
        //     right: -MediaQuery.of(context).size.width * .4,
        //     child: BezierContainer())
      ],
    ));
  }

  /// -----------------------------------------
  /// Text title  header with helper method
  /// -----------------------------------------
  Widget _title() {
    /// -----------------------------------------
    /// make custom Text title with custom font, theme, color, size and font family.
    /// -----------------------------------------
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
            /// -----------------------------------------
            /// make custom Text title with custom color.
            /// -----------------------------------------
            TextSpan(
              text: 'S',
              style: TextStyle(color: Colors.blueAccent, fontSize: 30),
            ),

            /// -----------------------------------------
            /// make custom Text title with custom color.
            /// -----------------------------------------
            TextSpan(
              text: 'talk',
              style: TextStyle(color: Colors.red, fontSize: 30),
            ),
          ]),
    );
  }
}
